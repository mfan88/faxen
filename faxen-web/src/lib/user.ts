import "server-only";
import { currentUser, User } from "@clerk/nextjs/server";
import { db } from "./db";
import { createHash } from "node:crypto";
import { DEFAULT_SETTINGS, serializeSettings, settingsFromStore, storedSettingsNeedBackfill, SettingsList } from "./settings";

export interface UserSettings {
  userHash: string
  settings: string
}

export async function getCurrentUser(): Promise<{
  status: string;
  id: string;
}> {
  const user = await currentUser();
  if (!user) {
    return { status: "error", id: "" };
  } else {
    return { status: "success", id: user.id };
  }
}

export async function getUserName(): Promise<string | null> {
  const user = await currentUser();
  return user?.firstName ?? user?.primaryEmailAddress?.emailAddress ?? null;
}

export function hashUserId(userId: string): string {
  return createHash("sha256").update(userId).digest("hex");
}

export async function generateUserHash(user: User): Promise<string> {
  return hashUserId(user.id);
}



export async function getValidSettings(): Promise<{ status: string; settings: SettingsList | null }> {
  const user = await currentUser();
  if (!user) return { status: "error", settings: null };

  const userHash = await generateUserHash(user);
  const key = `settings:${userHash}`;
  const data = await db.get(key);

  if (!data) {
    await db.set(key, serializeSettings(DEFAULT_SETTINGS));
    return { status: "success", settings: DEFAULT_SETTINGS };
  }

  const settings = settingsFromStore(data);
  if (storedSettingsNeedBackfill(data)) {
    await db.set(key, serializeSettings(settings));
  }

  return { status: "success", settings };
}
