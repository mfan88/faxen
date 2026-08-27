import "server-only";
import { getCurrentUser, getValidSettings, hashUserId } from "@/lib/user";
import { db } from "@/lib/db";
import { generateUniqueToken, hashToken, TokenData, UserLinkSummary } from "./tokens";
import { getDefaultFileTypes } from "@/lib/files";

function linkKey(tokenHash: string) {
  return `link:${tokenHash}`;
}

function userLinksKey(userHash: string) {
  return `links:${userHash}`;
}

export async function purgeExpiredUserLinks(userHash: string) {
  await db.zremrangebyscore(userLinksKey(userHash), "-inf", Date.now());
}

async function detachLinkFromUser(userHash: string, tokenHash: string) {
  await Promise.all([
    db.del(linkKey(tokenHash)),
    db.zrem(userLinksKey(userHash), tokenHash),
  ]);
}

export async function createLink(
  message: string,
  expiresIn: number = 1,
): Promise<{ status: string; url: string }> {
  const user = await getCurrentUser();
  if (user.status !== "success") {
    return { status: "error", url: "" };
  }

  const userHash = hashUserId(user.id);
  const rawToken = generateUniqueToken();
  const tokenHash = hashToken(rawToken);
  const createdAt = Date.now();
  const expiryTime = expiresIn * 24 * 60 * 60;
  const expiresAt = createdAt + expiryTime * 1000;

  const { settings } = await getValidSettings();

  const tokenData: TokenData = {
    userId: user.id,
    userHash,
    tokenHash,
    createdAt,
    expiresAt,
    message,
    acceptedFileTypes: settings?.acceptedFileTypes ?? getDefaultFileTypes(),
  };

  await purgeExpiredUserLinks(userHash);

  await db
    .pipeline()
    .set(linkKey(tokenHash), tokenData, { ex: expiryTime })
    .zadd(userLinksKey(userHash), { score: expiresAt, member: tokenHash })
    .exec();

  return {
    status: "success",
    url: `${process.env.NODE_ENV === "development" ? process.env.NEXT_PUBLIC_DEV_URL : process.env.NEXT_PUBLIC_APP_URL}/upload/${rawToken}`,
  };
}

export async function getTokenData(
  rawToken: string,
): Promise<TokenData | null> {
  const tokenHash = hashToken(rawToken);
  const data = await db.get<TokenData>(linkKey(tokenHash));
  if (!data) return null;

  if (data.expiresAt <= Date.now()) {
    if (data.userHash) {
      await detachLinkFromUser(data.userHash, tokenHash);
    } else {
      await db.del(linkKey(tokenHash));
    }
    return null;
  }

  return data;
}

export async function getUserLinks(): Promise<UserLinkSummary[]> {
  const user = await getCurrentUser();
  if (user.status !== "success") return [];

  const userHash = hashUserId(user.id);
  await purgeExpiredUserLinks(userHash);

  const hashes = await db.zrange<string[]>(
    userLinksKey(userHash),
    Date.now(),
    "+inf",
    { byScore: true },
  );

  if (!hashes.length) return [];

  const records = await db.mget<(TokenData | null)[]>(
    ...hashes.map((tokenHash) => linkKey(tokenHash)),
  );

  const missing: string[] = [];
  const links: UserLinkSummary[] = [];

  hashes.forEach((tokenHash, index) => {
    const record = records[index];
    if (!record || record.expiresAt <= Date.now()) {
      missing.push(tokenHash);
      return;
    }
    links.push({
      message: record.message,
      createdAt: record.createdAt,
      expiresAt: record.expiresAt,
    });
  });

  if (missing.length) {
    await db.zrem(userLinksKey(userHash), ...missing);
  }

  return links;
}
