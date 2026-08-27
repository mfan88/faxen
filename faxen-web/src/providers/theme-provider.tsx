"use client";

import { useEffect, type ReactNode } from "react";
import { useSettings } from "@/providers/settings-provider";

export const THEME_EVENT = "faxen-theme";

function applyDarkClass(isDarkMode: boolean) {
  document.documentElement.classList.toggle("dark", isDarkMode);
}

export function ThemeProvider({ children }: { children: ReactNode }) {
  const { settings, setDarkMode } = useSettings();

  useEffect(() => {
    applyDarkClass(settings.isDarkMode);
  }, [settings.isDarkMode]);

  useEffect(() => {
    function onTheme(event: Event) {
      const isDarkMode = (event as CustomEvent<{ isDarkMode?: boolean }>).detail
        ?.isDarkMode;
      if (typeof isDarkMode === "boolean") {
        setDarkMode(isDarkMode);
      }
    }

    window.addEventListener(THEME_EVENT, onTheme);
    return () => window.removeEventListener(THEME_EVENT, onTheme);
  }, [setDarkMode]);

  return children;
}
