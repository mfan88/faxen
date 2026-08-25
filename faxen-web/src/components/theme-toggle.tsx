export function ThemeToggle() {
  return (
    <button
      type="button"
      data-theme-toggle=""
      aria-label="Toggle color theme"
      className="relative inline-flex h-10 w-[4.25rem] shrink-0 cursor-pointer items-center rounded-full border border-stone-900/10 bg-white/60 p-1 shadow-[0_8px_30px_rgba(28,25,23,0.06)] select-none dark:border-white/10 dark:bg-stone-950/50 dark:shadow-[0_8px_30px_rgba(0,0,0,0.35)]"
    >
      <span className="pointer-events-none absolute top-1 left-1 h-8 w-8 rounded-full bg-white shadow-sm transition-transform duration-300 ease-out dark:translate-x-[1.7rem] dark:bg-stone-900" />
      <span className="relative z-10 grid w-full grid-cols-2">
        <span className="flex h-8 items-center justify-center text-stone-700 dark:text-stone-500">
          <svg
            viewBox="0 0 24 24"
            className="h-4 w-4"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.75"
            aria-hidden
          >
            <circle cx="12" cy="12" r="4" />
            <path
              strokeLinecap="round"
              d="M12 3v1.5M12 19.5V21M4.93 4.93l1.06 1.06M18.01 18.01l1.06 1.06M3 12h1.5M19.5 12H21M4.93 19.07l1.06-1.06M18.01 5.99l1.06-1.06"
            />
          </svg>
        </span>
        <span className="flex h-8 items-center justify-center text-stone-400 dark:text-orange-200">
          <svg
            viewBox="0 0 24 24"
            className="h-4 w-4"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.75"
            aria-hidden
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M20 14.5A8.5 8.5 0 1 1 9.5 4 7 7 0 0 0 20 14.5Z"
            />
          </svg>
        </span>
      </span>
    </button>
  );
}
