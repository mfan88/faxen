"use client"
import { getSettingsAction, updateSettingsAction } from "@/app/dashboard/actions";
import { SettingsList, DEFAULT_SETTINGS, mergeWithDefaults } from "@/lib/settings";
import { useUser } from "@clerk/nextjs";
import { createContext, useContext, useState, useEffect, useCallback, useMemo, useRef, ReactNode } from "react";

type SettingsContextValue = {
  settings: SettingsList;
  isLoading: boolean;
  updateSettings: (next: SettingsList) => Promise<void>;
  setDarkMode: (isDarkMode: boolean) => void;
};

const SettingsContext = createContext<SettingsContextValue | null>(null);

function readInitialSettings(): SettingsList {
  if (typeof window === "undefined") return DEFAULT_SETTINGS;
  try {
    const local = localStorage.getItem("settings");
    if (local) return mergeWithDefaults(JSON.parse(local));
    const theme = localStorage.getItem("theme");
    if (theme === "dark") return { ...DEFAULT_SETTINGS, isDarkMode: true };
    if (theme === "light") return { ...DEFAULT_SETTINGS, isDarkMode: false };
  } catch {
    /* use defaults */
  }
  return DEFAULT_SETTINGS;
}

function persistSettings(next: SettingsList) {
  localStorage.setItem("settings", JSON.stringify(next));
  localStorage.setItem("theme", next.isDarkMode ? "dark" : "light");
}

export function SettingsProvider({ children }: { children: ReactNode }) {
  const [settings, setSettings] = useState<SettingsList>(readInitialSettings);
  const [isLoading, setIsLoading] = useState(true);
  const { isLoaded, isSignedIn } = useUser();
  const settingsRef = useRef(settings);
  settingsRef.current = settings;

  useEffect(() => {
    if (!isLoaded) return;
    if (!isSignedIn) {
      setIsLoading(false);
      return;
    }

    let cancelled = false;
    (async () => {
      const { status, settings: fetched } = await getSettingsAction();
      if (!cancelled && status === "success" && fetched) {
        const next = mergeWithDefaults(fetched);
        setSettings(next);
        persistSettings(next);
      }
      setIsLoading(false);
    })();
    return () => {
      cancelled = true;
    };
  }, [isLoaded, isSignedIn]);

  const updateSettings = useCallback(
    async (next: SettingsList) => {
      setSettings(next);
      persistSettings(next);
      if (isSignedIn) await updateSettingsAction(next);
    },
    [isSignedIn],
  );

  const setDarkMode = useCallback(
    (isDarkMode: boolean) => {
      const prev = settingsRef.current;
      if (prev.isDarkMode === isDarkMode) return;
      const next = { ...prev, isDarkMode };
      settingsRef.current = next;
      setSettings(next);
      persistSettings(next);
      if (isSignedIn) void updateSettingsAction(next);
    },
    [isSignedIn],
  );

  const value = useMemo(
    () => ({ settings, isLoading, updateSettings, setDarkMode }),
    [settings, isLoading, updateSettings, setDarkMode],
  );

  return (
    <SettingsContext.Provider value={value}>
      {children}
    </SettingsContext.Provider>
  );
}

export function useSettings() {
  const ctx = useContext(SettingsContext);
  if (!ctx) throw new Error("useSettings must be used within SettingsProvider");
  return ctx;
}