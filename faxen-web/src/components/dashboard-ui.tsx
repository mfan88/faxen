import type { ReactNode } from "react";
import { cn } from "@/lib/utils";

function Card({
  title,
  children,
  className,
  ...props
}: {
  title: string;
  children: ReactNode;
} & React.HTMLAttributes<HTMLDivElement>) {
  return (
    <article
      className={cn(
        "flex h-full flex-col rounded-2xl border border-border bg-card p-5 backdrop-blur-md",
        className,
      )}
      {...props}
    >
      <header>
        <h2 className="text-lg font-semibold tracking-tight">{title}</h2>
      </header>
      <div className="mt-4 min-h-0 flex-1">{children}</div>
    </article>
  );
}

export { Card };
