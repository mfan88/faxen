"use client";

function toggleTheme() {
  const isDark = document.documentElement.classList.toggle("dark");
  localStorage.setItem("theme", isDark ? "dark" : "light");
}

export function ThemeToggle() {
  return (
    <button
      type="button"
      onClick={toggleTheme}
      aria-label="Toggle color theme"
      className="group relative inline-flex h-10 w-[4.25rem] shrink-0 items-center rounded-full border border-stone-900/10 bg-white/60 p-1 shadow-[0_8px_30px_rgba(28,25,23,0.06)] backdrop-blur-md transition-colors dark:border-white/10 dark:bg-stone-950/50 dark:shadow-[0_8px_30px_rgba(0,0,0,0.35)]"
    >
      <span className="absolute inset-0 rounded-full ring-1 ring-inset ring-white/70 dark:ring-white/5" />
      <span className="relative z-10 flex h-8 w-8 items-center justify-center rounded-full bg-white text-stone-700 shadow-sm transition-transform duration-300 ease-out dark:translate-x-[1.7rem] dark:bg-stone-900 dark:text-orange-200">
        <svg
          viewBox="0 0 24 24"
          className="h-4 w-4 dark:hidden"
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
        <svg
          viewBox="0 0 24 24"
          className="hidden h-4 w-4 dark:block"
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
    </button>
  );
}
