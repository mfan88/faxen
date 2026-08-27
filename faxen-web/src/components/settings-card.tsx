"use client"

import { useSettings } from "@/providers/settings-provider"

export default function SettingsCard() {
    const { settings } = useSettings()

    return (
        <span>Dark Mode: {settings.isDarkMode ? "On" : "Off"}</span>
    )
}