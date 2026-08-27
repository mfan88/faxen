import { FoxLockup } from "@/components/fox-mark";
import { ThemeToggle } from "@/components/theme-toggle";
import { Card } from "@/components/dashboard-ui";
import { getUserName } from "@/lib/user";
import { getUserLinks } from "@/lib/links";
import { Links } from "@/components/links";
import SettingsCard from "@/components/settings-card";

export default async function DashboardPage() {
  const [name, userLinks] = await Promise.all([getUserName(), getUserLinks()]);

  return (
    <div className="relative flex min-h-full flex-1 flex-col">
      <header className="flex items-center justify-between px-5 py-5 sm:px-8 sm:py-6 lg:px-12">
        <a href="/" className="flex items-center gap-2.5 text-foreground">
          <FoxLockup />
          <span className="text-[15px] font-semibold tracking-tight">
            faxen
          </span>
        </a>
        <ThemeToggle />
      </header>
      <main className="mx-auto flex w-full max-w-5xl flex-1 flex-col px-6 py-10">
        <h1 className="font-serif text-3xl tracking-tight">
          welcome {name ? "back, " + name.toLowerCase() : "!"}.
        </h1>
        <div className="mt-6 grid grid-cols-1 gap-4 lg:grid-cols-[minmax(0,1fr)_17.5rem]">
          <Card title="your links" className="min-h-80">
            <Links links={userLinks} />
          </Card>
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-1">
            <Card title="link settings" className="aspect-square">
              <div>Your Tasks</div>
            </Card>
            <Card title="file links" className="aspect-square">
              <div>Your Messages</div>
            </Card>
          </div>
        </div>
          <SettingsCard />
      </main>
    </div>
  );
}
