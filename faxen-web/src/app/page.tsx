import { auth } from "@clerk/nextjs/server";
import { redirect } from "next/navigation";
import { SiteHeader } from "@/components/site-header";
import { Key, Lock, Upload } from "lucide-react";

const features = [
  {
    title: "encrypted by default",
    body: "every transfer is wrapped in transit and at rest, so sensitive files stay that way.",
    icon: Lock,
  },
  {
    title: "share on your terms",
    body: "expiring links, access lists, and one-click revocation — you decide who sees what, and for how long.",
    icon: Key,
  },
  {
    title: "built for every file",
    body: "from a single PDF to a full project archive. drop it in, send the link, move on.",
    icon: Upload,
  },
];

export default async function Home() {
  const { userId, getToken } = await auth();
  const token = userId ? await getToken() : null;
  if (userId && token) {
    redirect("/dashboard");
  }

  return (
    <div className="relative flex min-h-dvh flex-col lg:h-dvh lg:max-h-dvh lg:overflow-hidden">
      <SiteHeader />

      <main className="mx-auto flex min-h-0 w-full max-w-5xl flex-1 flex-col items-center px-4 pb-6 pt-4 sm:px-8 sm:pt-6">
        <p className="mb-4 rounded-full border border-border bg-card px-3 py-1 text-center text-xs font-medium tracking-wide text-muted-foreground backdrop-blur-md">
          built by fenna.tech
        </p>

        <h1 className="max-w-3xl text-center font-serif text-[1.85rem] leading-[1.15] tracking-tight text-foreground sm:text-5xl sm:leading-[1.08] lg:text-[4.35rem]">
          a secure upload portal
          <br className="hidden sm:block" /> for{" "}
          <em className="italic text-brand">all your needs.</em>
        </h1>

        <p className="mt-4 max-w-xl text-center text-sm leading-6 text-muted-foreground sm:mt-5 sm:text-lg sm:leading-8">
          send files with confidence. encrypted, access-controlled, and built
          for the moments when an email attachment isn&apos;t enough.
        </p>

        <div className="mt-6 flex w-full max-w-sm flex-col items-stretch gap-3 sm:mt-7 sm:max-w-none sm:flex-row sm:items-center sm:justify-center">
          <a
            href="/"
            className="inline-flex h-12 items-center justify-center rounded-full bg-brand px-7 text-sm font-semibold text-white shadow-[0_12px_32px_rgba(194,65,12,0.32)] transition-transform hover:scale-[1.02] active:scale-[0.98]"
          >
            coming soon
          </a>
          <a
            href="#how"
            className="inline-flex h-12 items-center justify-center rounded-full border border-border bg-card px-7 text-sm font-semibold text-foreground backdrop-blur-md transition-colors hover:bg-white/80 dark:hover:bg-stone-900/70"
          >
            how it works
          </a>
        </div>

        <section
          id="how"
          className="mt-8 grid w-full min-h-0 grid-cols-1 gap-3 sm:mt-10 sm:grid-cols-3 sm:gap-4"
        >
          {features.map((feature) => (
            <article
              key={feature.title}
              className="rounded-2xl border border-border bg-card p-4 backdrop-blur-md sm:p-5"
            >
              <span className="mb-3 flex h-9 w-9 items-center justify-center rounded-xl bg-white/70 text-brand dark:bg-stone-900/70">
                <feature.icon className="h-4 w-4" />
              </span>
              <h2 className="text-[15px] font-semibold tracking-tight text-foreground">
                {feature.title}
              </h2>
              <p className="mt-2 text-sm leading-6 text-muted-foreground">
                {feature.body}
              </p>
            </article>
          ))}
        </section>

        <p className="mt-8 text-center text-xs text-muted-foreground lg:mt-auto lg:pt-4">
          © {new Date().getFullYear()} faxen. files made easy.
        </p>
      </main>
    </div>
  );
}
