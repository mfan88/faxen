import { SiteHeader } from "@/components/site-header";

export default function AuthLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <div className="relative flex min-h-dvh flex-1 flex-col overflow-x-hidden">
      <SiteHeader />
      <main className="flex w-full min-w-0 flex-1 items-start justify-center px-4 py-6 sm:items-center sm:px-6 sm:pb-16">
        <div className="flex w-full max-w-[min(100%,28rem)] justify-center overflow-x-auto">
          {children}
        </div>
      </main>
    </div>
  );
}
