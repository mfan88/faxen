export function FoxMark({ className }: Readonly<{ className?: string }>) {
  return (
    <svg
      viewBox="0 0 32 32"
      className={className}
      fill="currentColor"
      aria-hidden
    >
      <path d="M5.5 13.2 11.2 2.8a1 1 0 0 1 1.76.08L16 8.4l3.04-5.52a1 1 0 0 1 1.76-.08l5.7 10.4c.5.9-.1 2-1.1 2.14l-1.7.24 1.2 10.6c.16 1.36-1.3 2.36-2.5 1.7L16 24.6 8.9 28.2c-1.2.66-2.66-.34-2.5-1.7l1.2-10.6-1.7-.24c-1-.14-1.6-1.24-1.1-2.14Z" />
      <path
        d="M11.2 14.6c1.5.7 3.1 1.1 4.8 1.1s3.3-.4 4.8-1.1L16 25.2 11.2 14.6Z"
        className="fill-white dark:fill-[#1a1512]"
      />
    </svg>
  );
}
