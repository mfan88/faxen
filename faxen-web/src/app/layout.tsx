import type { Metadata } from "next";
import { Geist, Geist_Mono, Instrument_Serif } from "next/font/google";
import "./globals.css";

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

const themeScript = `(function(){try{var s=localStorage.getItem("theme");var d=s==="dark"||(s!=="light"&&window.matchMedia("(prefers-color-scheme: dark)").matches);document.documentElement.classList.toggle("dark",d);}catch(e){}var last=0;function toggle(e){var t=e.target&&e.target.closest?e.target.closest("[data-theme-toggle]"):null;if(!t)return;e.preventDefault();e.stopPropagation();var now=Date.now();if(now-last<400)return;last=now;var isDark=document.documentElement.classList.toggle("dark");try{localStorage.setItem("theme",isDark?"dark":"light");}catch(err){}}document.addEventListener("click",toggle,true);document.addEventListener("touchstart",toggle,{capture:true,passive:false});})();`;

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
      className={`${geistSans.variable} ${geistMono.variable} ${instrumentSerif.variable} h-full antialiased`}
    >
      <head>
        <script dangerouslySetInnerHTML={{ __html: themeScript }} />
      </head>
      <body className="min-h-full flex flex-col">{children}</body>
    </html>
  );
}
