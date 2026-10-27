import { cookies } from "next/headers";
import { getIronSession, type SessionOptions } from "iron-session";
export type PortalUser={id:string;username:string;global_name?:string|null;avatar?:string|null;isAdmin:boolean};
type SessionData={user?:PortalUser;oauthState?:string};
const options:SessionOptions={cookieName:"wizzair_portal",password:process.env.SESSION_PASSWORD||"development-only-password-change-this-000000",cookieOptions:{httpOnly:true,secure:process.env.NODE_ENV==="production",sameSite:"lax",path:"/",maxAge:60*60*24*7}};
export async function session(){return getIronSession<SessionData>(await cookies(),options)}
export async function getUser(){const s=await session();return s.user??null}
export function isAdminId(id:string){return (process.env.ADMIN_DISCORD_IDS||"").split(",").map(x=>x.trim()).filter(Boolean).includes(id)}
export async function requireAdmin(){const u=await getUser();if(!u||!u.isAdmin)throw new Error("FORBIDDEN");return u}
