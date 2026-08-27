import { FoxLockup } from "@/components/fox-mark";
import { ThemeToggle } from "@/components/theme-toggle";

export default function AuthLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <div className="relative flex min-h-full flex-1 flex-col">
      <header className="flex items-center justify-between px-5 py-5 sm:px-8 sm:py-6 lg:px-12">
        <a href="/" className="flex items-center gap-2.5 text-foreground">
          <FoxLockup />
          <span className="text-[15px] font-semibold tracking-tight">faxen</span>
        </a>
        <ThemeToggle />
      </header>
      <main className="flex flex-1 items-center justify-center px-4 pb-16">
        {children}
      </main>
    </div>
  );
}
