"use server";

import { db } from "@/lib/db";
import { createLink } from "@/lib/links";
import { SettingsList, serializeSettings, mergeWithDefaults } from "@/lib/settings";
import { generateUserHash, getValidSettings } from "@/lib/user";
import { currentUser } from "@clerk/nextjs/server";

export async function createLinkAction(message: string) {
  return createLink(message);
}

export async function getSettingsAction() {
  return getValidSettings()
}

export async function updateSettingsAction(next: SettingsList) {
  const user = await currentUser();
  if (!user) return { status: "error" };
  const userHash = await generateUserHash(user);
  await db.set(`settings:${userHash}`, serializeSettings(mergeWithDefaults(next)));
  return { status: "success" };
}