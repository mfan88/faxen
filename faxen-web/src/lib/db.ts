import "server-only";
import { Redis } from "@upstash/redis";

declare global {
  var redisDB: Redis | undefined;
}

export const db =
  global.redisDB ||
  new Redis({
    url: process.env.UPSTASH_REDIS_REST_URL!,
    token: process.env.UPSTASH_REDIS_REST_TOKEN!,
  });

if (process.env.NODE_ENV !== "production") {
  global.redisDB = db;
}
