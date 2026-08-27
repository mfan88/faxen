import { cn } from "@/lib/utils";

const FOX_HEAD =
  "M6.3 10.7 9 3.4 12 9.1 15 3.4 17.7 10.7 20.4 13.5 17.4 20.2 12 21.4 6.6 20.2 3.6 13.5Z";
const FOX_EARS = "M9.4 8.5 10.3 5.8M13.7 5.8 14.6 8.5";
const FOX_SNOUT = "M10.45 16.15 12 18.2l1.55-2.05";

type FoxTone = "current" | "black" | "white";

const toneColor: Record<FoxTone, string> = {
  current: "currentColor",
  black: "#111111",
  white: "#ffffff",
};

export function FoxMark({
  className,
  tone = "current",
}: Readonly<{ className?: string; tone?: FoxTone }>) {
  const color = toneColor[tone];

  return (
    <svg
      viewBox="0 0 24 24"
      className={className}
      fill="none"
      stroke={color}
      strokeWidth="1.55"
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden
    >
      <FoxLines color={color} />
    </svg>
  );
}

function FoxLines({ color }: Readonly<{ color: string }>) {
  return (
    <>
      <path d={FOX_HEAD} />
      <path d={FOX_EARS} />
      <circle cx="10.2" cy="13.35" r="0.7" fill={color} stroke="none" />
      <circle cx="13.8" cy="13.35" r="0.7" fill={color} stroke="none" />
      <path d={FOX_SNOUT} />
    </>
  );
}

export function FoxLockup({ className }: Readonly<{ className?: string }>) {
  return (
    <span className={cn("relative inline-flex h-9 w-9 shrink-0", className)}>
      <span
        aria-hidden
        className="pointer-events-none absolute -inset-1.5 rounded-2xl bg-brand/70 blur-lg dark:bg-brand/55 dark:blur-md"
      />
      <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 32 32"
        fill="none"
        className="relative h-9 w-9"
        aria-hidden
      >
        <rect width="32" height="32" rx="8" fill="#c2410c" />
        <g
          transform="translate(4 4)"
          stroke="#111111"
          strokeWidth="1.55"
          strokeLinecap="round"
          strokeLinejoin="round"
        >
          <path d="M6.3 10.7 9 3.4 12 9.1 15 3.4 17.7 10.7 20.4 13.5 17.4 20.2 12 21.4 6.6 20.2 3.6 13.5Z" />
          <path d="M9.4 8.5 10.3 5.8M13.7 5.8 14.6 8.5" />
          <circle cx="10.2" cy="13.35" r="0.7" fill="#111111" stroke="none" />
          <circle cx="13.8" cy="13.35" r="0.7" fill="#111111" stroke="none" />
          <path d="M10.45 16.15 12 18.2l1.55-2.05" />
        </g>
      </svg>
    </span>
  );
}
