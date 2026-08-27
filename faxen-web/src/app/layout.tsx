import type { Metadata } from "next";
import { Geist, Geist_Mono, Instrument_Serif, Outfit } from "next/font/google";
import { AppClerkProvider } from "@/providers/clerk-provider";
import { Toaster } from "@/components/ui/toast";
import "./globals.css";
import { cn } from "@/lib/utils";
import { SettingsProvider } from "@/providers/settings-provider";
import { ThemeProvider } from "@/providers/theme-provider";

const instrumentSerifHeading = Instrument_Serif({subsets:['latin'],weight:['400'],variable:'--font-heading'});

const outfit = Outfit({subsets:['latin'],variable:'--font-sans'});

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

const instrumentSerif = Instrument_Serif({
  variable: "--font-instrument",
  subsets: ["latin"],
  weight: "400",
  style: ["normal", "italic"],
});

const themeScript = `(function(){function readDark(){try{var raw=localStorage.getItem("settings");if(raw){var p=JSON.parse(raw);if(typeof p.isDarkMode==="boolean")return p.isDarkMode;}var s=localStorage.getItem("theme");if(s==="dark")return true;if(s==="light")return false;}catch(e){}return window.matchMedia("(prefers-color-scheme: dark)").matches;}function writeDark(isDark){try{var raw=localStorage.getItem("settings");var p=raw?JSON.parse(raw):{};p.isDarkMode=isDark;localStorage.setItem("settings",JSON.stringify(p));localStorage.setItem("theme",isDark?"dark":"light");}catch(e){}try{window.dispatchEvent(new CustomEvent("faxen-theme",{detail:{isDarkMode:isDark}}));}catch(e){}}try{document.documentElement.classList.toggle("dark",readDark());}catch(e){}var last=0;function toggle(e){var t=e.target&&e.target.closest?e.target.closest("[data-theme-toggle]"):null;if(!t)return;e.preventDefault();e.stopPropagation();var now=Date.now();if(now-last<400)return;last=now;var isDark=document.documentElement.classList.toggle("dark");writeDark(isDark);}document.addEventListener("click",toggle,true);document.addEventListener("touchstart",toggle,{capture:true,passive:false});})();`;

export const metadata: Metadata = {
  title: "faxen — files made easy",
  description:
    "Faxen is a secure upload portal for sending files with encryption, access control, and nothing left to chance.",
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html
      lang="en"
      suppressHydrationWarning
      className={cn("h-full", "antialiased", geistSans.variable, geistMono.variable, instrumentSerif.variable, "font-sans", outfit.variable, instrumentSerifHeading.variable)}
    >
      <head>
        <script dangerouslySetInnerHTML={{ __html: themeScript }} />
      </head>
      <body className="min-h-full flex flex-col">
        <AppClerkProvider>
          <SettingsProvider>
            <ThemeProvider>
              <Toaster>{children}</Toaster>
            </ThemeProvider>
          </SettingsProvider>
        </AppClerkProvider>
      </body>
    </html>
  );
}
