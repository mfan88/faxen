import { randomBytes, createHash } from "node:crypto";
import type { AcceptedFileTypes } from "@/lib/files";

export interface TokenData {
    userId: string;
    userHash?: string;
    tokenHash: string;
    createdAt: number;
    expiresAt: number;
    message: string;
    acceptedFileTypes?: AcceptedFileTypes;
}

export type UserLinkSummary = {
    message: string;
    createdAt: number;
    expiresAt: number;
};

export function generateUniqueToken(bytes: number = 32): string {
    return randomBytes(bytes).toString("base64url");
}

export function hashToken(rawToken: string): string {
    return createHash("sha256").update(rawToken).digest("hex");
}

