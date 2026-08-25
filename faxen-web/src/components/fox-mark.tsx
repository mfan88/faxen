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
    <span
      className={`flex h-9 w-9 items-center justify-center rounded-xl bg-accent text-white shadow-[0_8px_24px_rgba(194,65,12,0.28)] dark:text-black ${className ?? ""}`}
    >
      <FoxMark className="h-6 w-6" />
    </span>
  );
}
