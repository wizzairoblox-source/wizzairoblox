import { NextResponse } from "next/server";
export function jsonError(message:string,status=400){return NextResponse.json({error:message},{status})}
export function safeError(error:unknown){if(error instanceof Error&&error.message==="FORBIDDEN")return jsonError("Brak uprawnień administratora.",403);console.error(error);return jsonError("Wystąpił błąd serwera.",500)}
export function text(value:unknown,max=5000){return typeof value==="string"?value.trim().slice(0,max):""}
