import { getDefaultFileTypes, type AcceptedFileTypes } from "@/lib/files"

export type LinkBufferTime = {
    enabled: boolean
    units: "seconds" | "minutes" | "hours" | "days"
    time: number
}

export type SettingsList = {
    isDarkMode: boolean
    isCompact: boolean
    textMagnification: number
    linkLifeCycleDays: number
    linkBufferTime: LinkBufferTime
    acceptedFileTypes: AcceptedFileTypes
}

export const DEFAULT_SETTINGS: SettingsList = {
    isDarkMode: false,
    isCompact: false,
    textMagnification: 1,
    linkLifeCycleDays: 1,
    linkBufferTime: {
        enabled: false,
        units: "days",
        time: 0
    },
    acceptedFileTypes: getDefaultFileTypes(),
}

export function serializeSettings(settings: SettingsList): string {
    return JSON.stringify(settings);
}

export function mergeWithDefaults(parsed: Partial<SettingsList>): SettingsList {
    return {
      ...DEFAULT_SETTINGS,
      ...parsed,
      linkBufferTime: {
        ...DEFAULT_SETTINGS.linkBufferTime,
        ...(parsed.linkBufferTime ?? {}),
      },
      acceptedFileTypes: {
        ...DEFAULT_SETTINGS.acceptedFileTypes,
        ...(parsed.acceptedFileTypes ?? {}),
      },
    };
}

export function settingsFromStore(data: unknown): SettingsList {
    if (data == null) return DEFAULT_SETTINGS;
    if (typeof data === "string") return deserializeSettings(data);
    if (typeof data === "object") {
      return mergeWithDefaults(data as Partial<SettingsList>);
    }
    return DEFAULT_SETTINGS;
}

function storedObject(data: unknown): Record<string, unknown> | null {
    if (data != null && typeof data === "object") {
      return data as Record<string, unknown>;
    }
    if (typeof data === "string") {
      try {
        const parsed = JSON.parse(data);
        if (parsed != null && typeof parsed === "object") {
          return parsed as Record<string, unknown>;
        }
      } catch {
        return null;
      }
    }
    return null;
}

export function storedSettingsNeedBackfill(data: unknown): boolean {
    const stored = storedObject(data);
    if (!stored) return true;
    return !("acceptedFileTypes" in stored);
}

export function deserializeSettings(json: string | null): SettingsList {
    if (!json) return DEFAULT_SETTINGS;
    try {
      return mergeWithDefaults(JSON.parse(json) as Partial<SettingsList>);
    } catch {
      return DEFAULT_SETTINGS;
    }
}