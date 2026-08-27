"use client";

import { ClerkProvider } from "@clerk/nextjs";

export function AppClerkProvider({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <ClerkProvider
      appearance={{
        variables: {
          colorPrimary: "#c2410c",
        },
      }}
    >
      {children}
    </ClerkProvider>
  );
}
