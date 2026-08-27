import { FoxLockup } from "@/components/fox-mark";
import { ThemeToggle } from "@/components/theme-toggle";

export function SiteHeader() {
  return (
    <header className="flex shrink-0 items-center justify-between gap-3 px-4 py-4 sm:px-8 sm:py-5 lg:px-12">
      <a
        href="/"
        className="flex min-w-0 items-center gap-2 text-foreground sm:gap-2.5"
      >
        <FoxLockup />
        <span className="truncate text-[15px] font-semibold tracking-tight">
          faxen
        </span>
      </a>
      <ThemeToggle />
    </header>
  );
}
