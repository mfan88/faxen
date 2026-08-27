import { SiteHeader } from "@/components/site-header";
import { Card } from "@/components/dashboard-ui";
import { getUserName } from "@/lib/user";
import { getUserLinks } from "@/lib/links";
import { Links } from "@/components/links";
import SettingsCard from "@/components/settings-card";

export default async function DashboardPage() {
  const [name, userLinks] = await Promise.all([getUserName(), getUserLinks()]);

  return (
    <div className="relative flex min-h-dvh flex-1 flex-col overflow-x-hidden">
      <SiteHeader />
      <main className="mx-auto flex w-full max-w-5xl flex-1 flex-col px-4 py-6 sm:px-6 sm:py-10">
        <h1 className="font-serif text-2xl tracking-tight break-words sm:text-3xl">
          welcome {name ? "back, " + name.toLowerCase() : "!"}.
        </h1>
        <div className="mt-6 grid grid-cols-1 gap-4 lg:grid-cols-[minmax(0,1fr)_minmax(14rem,17.5rem)]">
          <Card title="your links" className="min-h-64 sm:min-h-80">
            <Links links={userLinks} />
          </Card>
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-1">
            <Card
              title="link settings"
              className="min-h-48 sm:aspect-square sm:min-h-0"
            >
              <div>Your Tasks</div>
            </Card>
            <Card
              title="file links"
              className="min-h-48 sm:aspect-square sm:min-h-0"
            >
              <div>Your Messages</div>
            </Card>
          </div>
        </div>
        <div className="mt-6">
          <SettingsCard />
        </div>
      </main>
    </div>
  );
}
