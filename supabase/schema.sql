-- Uruchom caly plik w Supabase SQL Editor.
create extension if not exists pgcrypto;
create table if not exists public.announcements (
 id uuid primary key default gen_random_uuid(), title text not null, summary text not null default '', body text not null,
 category text not null default 'Aktualności', published boolean not null default true, created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.applications (
 id uuid primary key default gen_random_uuid(), discord_id text not null, discord_username text not null, role text not null,
 answers jsonb not null default '{}'::jsonb, status text not null default 'pending' check (status in ('pending','accepted','rejected')),
 review_note text, reviewed_at timestamptz, quiz_score integer, quiz_total integer, quiz_passed boolean, quiz_completed_at timestamptz,
 created_at timestamptz not null default now()
);
create index if not exists applications_discord_id_idx on public.applications(discord_id);
create index if not exists applications_status_idx on public.applications(status);
create table if not exists public.site_content (key text primary key, value jsonb not null default '{}'::jsonb, updated_at timestamptz not null default now());
create table if not exists public.recruitment_stages (id uuid primary key default gen_random_uuid(), title text not null, description text not null default '', position integer not null default 0, enabled boolean not null default true);
create table if not exists public.quiz_questions (id uuid primary key default gen_random_uuid(), question text not null, options jsonb not null, correct_index integer not null check (correct_index >= 0), position integer not null default 0, enabled boolean not null default true);
alter table public.announcements enable row level security;
alter table public.applications enable row level security;
alter table public.site_content enable row level security;
alter table public.recruitment_stages enable row level security;
alter table public.quiz_questions enable row level security;
-- Celowo brak publicznych policies. Tabele czyta/zapisuje tylko backend przy uzyciu service role.
insert into public.site_content(key,value) values ('career','{"intro":"Rozpocznij swoją przygodę z Wizz Air Roblox RP. Zaloguj się przez Discord, wypełnij podanie i sprawdzaj status rekrutacji na tej stronie."}'::jsonb),('training','{"title":"Wprowadzenie do zespołu","body":"Dodaj materiały szkoleniowe w panelu administratora."}'::jsonb),('quiz_settings','{"passPercent":70}'::jsonb) on conflict(key) do nothing;
insert into public.recruitment_stages(title,description,position,enabled) select 'Podanie','Uzupełnij formularz rekrutacyjny.',1,true where not exists(select 1 from public.recruitment_stages);
insert into public.recruitment_stages(title,description,position,enabled) select 'Szkolenie','Po akceptacji zapoznaj się z materiałami.',2,true where (select count(*) from public.recruitment_stages)<2;
insert into public.recruitment_stages(title,description,position,enabled) select 'Quiz','Sprawdź swoją wiedzę w krótkim quizie.',3,true where (select count(*) from public.recruitment_stages)<3;
