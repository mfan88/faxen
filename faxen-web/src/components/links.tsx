"use client";

import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { toast } from "@/components/ui/toast";
import { createLinkAction } from "@/app/dashboard/actions";

export function Links({
  links,
}: {
  links: { message: string; createdAt: number; expiresAt: number }[];
}) {
  const router = useRouter();

  async function handleClick() {
    const link = await createLinkAction("hello, world");
    toast.add({
      title: "link created — click to copy",
      description: link.url,
      data: { copyText: link.url },
    });
    router.refresh();
  }

  return (
    <div className="flex flex-col gap-4">
      <Button variant="secondary" onClick={handleClick}>
        Create Link
      </Button>
      {links.length > 0 ? (
        <ul className="flex flex-col gap-2 text-sm text-muted-foreground">
          {links.map((link) => (
            <li key={`${link.createdAt}-${link.message}`}>
              expires {new Date(link.expiresAt).toLocaleDateString()}
            </li>
          ))}
        </ul>
      ) : (
        <p className="text-sm text-muted-foreground">no active links</p>
      )}
    </div>
  );
}
