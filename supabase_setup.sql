-- ============================================================
-- IA-Veille — initialisation de la base Supabase
-- A executer dans le SQL Editor de ton projet Supabase
-- (Dashboard > SQL Editor > New query > coller > Run)
-- ============================================================

-- Table des sources a surveiller (pilotable sans toucher au code)
create table if not exists public.sources (
    id                 uuid primary key default gen_random_uuid(),
    name               text not null,
    url                text not null,
    domain             text default 'undefined',
    article_link_xpath text default '',
    content_xpath      text default '',
    active             boolean not null default true,
    created_at         timestamptz not null default now()
);

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

-- Quelques sources de depart (flux RSS : listing stable via //item/link/text(),
-- le contenu est ensuite extrait sur la page de l'article par le spider)
insert into public.sources (name, url, domain, article_link_xpath, content_xpath, active) values
    ('TechCrunch AI',   'https://techcrunch.com/category/artificial-intelligence/feed/', 'techcrunch.com',   '//item/link/text()', '', true),
    ('VentureBeat AI',  'https://venturebeat.com/category/ai/feed/',                     'venturebeat.com',  '//item/link/text()', '', true),
    ('Ars Technica AI', 'https://arstechnica.com/ai/feed/',                              'arstechnica.com',  '//item/link/text()', '', true)
on conflict do nothing;
