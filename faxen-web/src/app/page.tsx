import { FoxLockup } from "@/components/fox-mark";
import { ThemeToggle } from "@/components/theme-toggle";
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

export default function Home() {
  return (
    <div className="relative flex min-h-full flex-1 flex-col">
      <header className="flex items-center justify-between px-5 py-5 sm:px-8 sm:py-6 lg:px-12">
        <a href="/" className="flex items-center gap-2.5 text-foreground">
          <FoxLockup />
          <span className="text-[15px] font-semibold tracking-tight">faxen</span>
        </a>
        <ThemeToggle />
      </header>

      <main className="mx-auto flex w-full max-w-5xl flex-1 flex-col items-center px-6 pb-20 pt-6 sm:px-8 sm:pt-10 lg:pt-14">
        <p className="mb-5 rounded-full border border-border bg-card px-3 py-1 text-xs font-medium tracking-wide text-muted backdrop-blur-md">
          built by fenna.tech
        </p>

        <h1 className="max-w-3xl text-center font-serif text-[2.6rem] leading-[1.12] tracking-tight text-foreground sm:text-6xl sm:leading-[1.08] lg:text-[4.35rem]">
          a secure upload portal
          <br className="hidden sm:block" /> for{" "}
          <em className="italic text-accent">all your needs.</em>
        </h1>

        <p className="mt-6 max-w-xl text-center text-base leading-7 text-muted sm:text-lg sm:leading-8">
          send files with confidence. encrypted, access-controlled, and built
          for the moments when an email attachment isn&apos;t enough.
        </p>

        <div className="mt-9 flex flex-col items-center gap-3 sm:flex-row">
          <a
            href="#upload"
            className="inline-flex h-12 items-center justify-center rounded-full bg-accent px-7 text-sm font-semibold text-white shadow-[0_12px_32px_rgba(194,65,12,0.32)] transition-transform hover:scale-[1.02] active:scale-[0.98]"
          >
            get started
          </a>
          <a
            href="#how"
            className="inline-flex h-12 items-center justify-center rounded-full border border-border bg-card px-7 text-sm font-semibold text-foreground backdrop-blur-md transition-colors hover:bg-white/80 dark:hover:bg-stone-900/70"
          >
            how it works
          </a>
        </div>

        <section id="how" className="mt-20 grid w-full gap-4 sm:grid-cols-3">
          {features.map((feature) => (
            <article
              key={feature.title}
              className="rounded-2xl border border-border bg-card p-5 backdrop-blur-md"
            >
              <span className="mb-4 flex h-9 w-9 items-center justify-center rounded-xl bg-white/70 text-accent dark:bg-stone-900/70">
                <feature.icon className="h-4 w-4" />
              </span>
              <h2 className="text-[15px] font-semibold tracking-tight">
                {feature.title}
              </h2>
              <p className="mt-2 text-sm leading-6 text-muted">{feature.body}</p>
            </article>
          ))}
        </section>
      </main>

      <footer className="px-6 pb-8 text-center text-xs text-muted">
        © {new Date().getFullYear()} faxen. files made easy.
      </footer>
    </div>
  );
}
