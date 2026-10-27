# Wizz Air Roblox RP Portal

Portal Next.js + TypeScript + Tailwind CSS z logowaniem Discord, podaniami rekrutacyjnymi, panelem administratora, bazą Supabase, materiałami szkoleniowymi i quizem.

## Funkcje

* Strony Home, O nas, Ogłoszenia, Career i panel administratora.
* Discord OAuth2, walidacja parametru `state` i sesja w szyfrowanym ciasteczku HTTP-only.
* Podania zapisywane w Supabase. Użytkownik nie może złożyć kolejnego podania, gdy poprzednie oczekuje na decyzję lub jest zaakceptowane.
* Administratorzy są określani przez Discord ID w `ADMIN_DISCORD_IDS`, a uprawnienia są sprawdzane po stronie serwera.
* Administrator może akceptować i odrzucać podania, publikować i usuwać ogłoszenia, edytować tekst Career i szkolenia oraz włączać i wyłączać etapy.
* Po decyzji administratora aplikacja próbuje wysłać użytkownikowi DM przez bota Discord.
* Quiz jest sprawdzany po stronie serwera, a wynik zapisywany w bazie.
* Supabase RLS jest włączone; brak publicznych policies. Klucz service role używany jest tylko w backendzie.

## Wymagania

Node.js 20.9 lub nowszy, konto Supabase i aplikacja Discord. Darmowe plany zwykle wystarczą dla małej społeczności, ale mają limity. Supabase Free może usypiać nieaktywne projekty. Vercel oferuje darmowy adres `*.vercel.app`; sprawdź aktualne warunki i limity planów przed publikacją.

## Konfiguracja lokalna

1. Zainstaluj Node.js LTS: https://nodejs.org/.
2. W katalogu projektu uruchom `npm install`.
3. Skopiuj `.env.example` do `.env.local` i uzupełnij zmienne.
4. W Supabase utwórz projekt. W SQL Editor uruchom cały plik `supabase/schema.sql`.
5. W Discord Developer Portal utwórz Application. W OAuth2 dodaj Redirect URL: `http://localhost:3000/api/auth/discord/callback`.
6. W Discord OAuth skopiuj Client ID i Client Secret do zmiennych. Utwórz bota w zakładce Bot i skopiuj token do `DISCORD_BOT_TOKEN`.
7. Dodaj botowi dostęp do prywatnego kanału zespołu z uprawnieniami View Channel i Send Messages. Ustaw jego ID jako `DISCORD_APPLICATION_CHANNEL_ID`, jeśli chcesz otrzymywać powiadomienia o nowych podaniach.
8. Włącz Developer Mode w Discord, skopiuj swoje User ID i wpisz je do `ADMIN_DISCORD_IDS`. Kilka ID rozdziel przecinkami.
9. Wygeneruj sekret sesji, np. `openssl rand -base64 32`, i ustaw go jako `SESSION_PASSWORD`.
10. Uruchom `npm run dev`, otwórz http://localhost:3000.

## Zmienne środowiskowe

`NEXT_PUBLIC_SUPABASE_URL` to Project URL z Supabase. `SUPABASE_SERVICE_ROLE_KEY` to klucz service role z ustawień API. Ten drugi omija RLS i musi pozostać wyłącznie na serwerze. Nigdy nie używaj prefiksu `NEXT_PUBLIC_` dla sekretów. `DISCORD_REDIRECT_URI` musi być identyczny z adresem zarejestrowanym w Discord Developer Portal.

Bot może nie wysłać DM, gdy użytkownik ma wyłączone wiadomości prywatne lub Discord ograniczy wysyłkę. Status podania pozostanie zapisany w bazie. Bot nie nadaje automatycznie ról Discord.

## Publikacja na Vercel

1. Wypchnij projekt do repozytorium GitHub.
2. Zaimportuj repozytorium na https://vercel.com.
3. W Vercel Project Settings → Environment Variables dodaj zmienne z `.env.local`.
4. Zmień `NEXT_PUBLIC_SITE_URL` na adres wdrożenia, np. `https://twoj-projekt.vercel.app`.
5. Zmień `DISCORD_REDIRECT_URI` na `https://twoj-projekt.vercel.app/api/auth/discord/callback` i dodaj identyczny URL w Discord Developer Portal.
6. Wdróż aplikację ponownie po zapisaniu zmiennych.

## Panel administratora

Wejdź na `/admin` po zalogowaniu kontem z `ADMIN_DISCORD_IDS`. Podania możesz przeglądać, akceptować i odrzucać. Ogłoszenia dodajesz i usuwasz w panelu. Teksty Career i szkolenia edytuje się jako JSON. Przykładowe dane szkolenia:

```json
{"title":"Wprowadzenie do zespołu","body":"Treść materiałów szkoleniowych i instrukcje.","presentationUrl":"https://example.com/prezentacja"}
```

Pytania quizu edytuje się w Supabase Table Editor w tabeli `quiz_questions`. `options` to tablica JSON, a `correct_index` to indeks poprawnej odpowiedzi, zaczynając od 0. `enabled=true` publikuje pytanie. W `site_content` pod kluczem `quiz_settings` można ustawić `{"passPercent":70}`.

## Bezpieczeństwo i ograniczenia

* Ustaw długi losowy `SESSION_PASSWORD` przed publikacją.
* Sprawdzanie administratora odbywa się na serwerze, nie tylko przez ukrycie linku.
* Dane wejściowe są walidowane przez Zod, a zapytania do bazy odbywają się po stronie serwera.
* Publiczne polityki Supabase RLS nie są dodawane celowo. Frontend nie otrzymuje klucza service role.
* Przed publicznym uruchomieniem warto dodać rate limiting dla OAuth i formularza oraz politykę prywatności.
* Panel pozwala edytować treści, ogłoszenia i aktywność etapów, ale nie jest edytorem wizualnym typu drag-and-drop. Pytania quizu zarządza się przez Supabase Table Editor.
* To nieoficjalny projekt społecznościowy, niezwiązany z Wizz Air ani Roblox Corporation.
