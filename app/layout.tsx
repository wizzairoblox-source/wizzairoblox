import type { Metadata } from "next";
import "./globals.css";
import { Header } from "@/components/header";
export const metadata: Metadata = { title: "Wizz Air Roblox RP | Official Portal", description: "Official community portal for Wizz Air Roblox RP. News, recruitment and training." };
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) { return <html lang="pl"><body><Header />{children}<footer className="footer"><div className="container" style={{display:"flex",justifyContent:"space-between",gap:16,flexWrap:"wrap"}}><span>© {new Date().getFullYear()} Wizz Air Roblox RP</span><span>Fan project for Roblox. Not affiliated with Wizz Air or Roblox Corporation.</span></div></footer></body></html>; }
