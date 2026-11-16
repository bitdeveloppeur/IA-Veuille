-- ============================================================
-- IA-Veille — initialisation de la base Supabase
-- A executer dans le SQL Editor de ton projet Supabase
-- (Dashboard > SQL Editor > New query > coller > Run)
-- Re-executable : les sources existantes sont remplacees
-- ============================================================

-- Table des sources a surveiller (pilotable sans toucher au code)
-- use_playwright : true uniquement pour les sites rendus en JavaScript
create table if not exists public.sources (
    id                 uuid primary key default gen_random_uuid(),
    name               text not null,
    url                text not null,
    domain             text default 'undefined',
    article_link_xpath text default '',
    content_xpath      text default '',
    use_playwright     boolean not null default true,
    active             boolean not null default true,
    created_at         timestamptz not null default now()
);

-- Pour les bases creees avec une ancienne version du script
alter table public.sources add column if not exists use_playwright boolean not null default true;

-- Table des articles scrapes
create table if not exists public.articles (
    id           uuid primary key default gen_random_uuid(),
    title        text not null,
    url          text not null unique,
    source       text,
    domain       text,
    published_at timestamptz,
    summary      text,
    created_at   timestamptz not null default now()
);

create index if not exists articles_published_at_idx on public.articles (published_at desc);

-- Sources d'actualites du Burkina Faso (verifiees le 2026-11-16)
delete from public.sources;

insert into public.sources (name, url, domain, article_link_xpath, content_xpath, use_playwright, active) values
    -- Flux RSS : rapides, pas besoin de navigateur
    ('Burkina24', 'https://burkina24.com/feed/', 'burkina24.com', '//item/link/text()', '', false, true),
    ('AIB',       'https://aib.bf/feed/',         'aib.bf',       '//item/link/text()', '', false, true),
    -- Sites rendus en JavaScript : Playwright necessaire
    -- RTB : articles sous /ANNEE/MOIS/JOUR/slug/ (pattern /202x valide jusqu'en 2029)
    ('RTB',  'https://www.rtb.bf/', 'rtb.bf', '//a[contains(@href, ''/202'')]/@href', '', true, true),
    -- BF1 : articles sous /post/ID/ (site TV en JavaScript)
    ('BF1',  'https://bf1.tv/',     'bf1.tv', '//a[contains(@href, ''/post/'')]/@href', '', true, true);
