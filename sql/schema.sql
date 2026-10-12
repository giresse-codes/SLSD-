-- SLSD — schéma de base de données, phase 1 (Supabase / PostgreSQL)
-- Mode d'emploi : dans Supabase, ouvre « SQL Editor », colle ce fichier, puis « Run ».

-- 1) Les rôles d'utilisateur ('admin' ne peut jamais être choisi à l'inscription)
create type user_role as enum ('client', 'vendeur', 'freelance', 'admin');

-- 2) Profils (un profil par compte)
create table public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  full_name   text not null default '',
  role        user_role not null default 'client',
  city        text,
  phone       text,
  verified    boolean not null default false,   -- badge « vérifié », réservé à l'administrateur
  created_at  timestamptz not null default now()
);
alter table public.profiles enable row level security;
create policy "profil: lire le sien" on public.profiles for select using (auth.uid() = id);
create policy "profil: modifier le sien" on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);
-- Un utilisateur ne peut modifier que ces colonnes (jamais role ni verified) :
revoke update on public.profiles from authenticated;
grant update (full_name, city, phone) on public.profiles to authenticated;

-- 3) Création automatique du profil à l'inscription
create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
declare r text := new.raw_user_meta_data->>'role';
begin
  insert into public.profiles (id, full_name, role, city, phone)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', ''),
    case when r in ('client', 'vendeur', 'freelance') then r::user_role else 'client'::user_role end,
    new.raw_user_meta_data->>'city',
    new.raw_user_meta_data->>'phone'
  );
  return new;
end $$;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();

-- 4) Offres (produits, services, profils de professionnels)
create table public.listings (
  id          bigint generated always as identity primary key,
  owner_id    uuid not null references public.profiles(id) on delete cascade,
  kind        text not null check (kind in ('produit', 'service', 'talent')),
  univers     text not null,
  title       text not null,
  description text,
  price_xaf   integer check (price_xaf >= 0),
  price_label text,                              -- ex. « dès », « sur devis »
  city        text,
  image_url   text,
  status      text not null default 'pending' check (status in ('pending', 'active', 'hidden')),
  created_at  timestamptz not null default now()
);
alter table public.listings enable row level security;
create policy "offres: voir les actives ou les siennes" on public.listings for select
  using (status = 'active' or owner_id = auth.uid());
create policy "offres: créer (vendeur ou professionnel)" on public.listings for insert
  with check (
    owner_id = auth.uid() and status = 'pending'
    and exists (select 1 from public.profiles p where p.id = auth.uid() and p.role in ('vendeur', 'freelance'))
  );
create policy "offres: modifier les siennes" on public.listings for update
  using (owner_id = auth.uid()) with check (owner_id = auth.uid());
revoke update on public.listings from authenticated;
grant update (title, description, price_xaf, price_label, city, image_url) on public.listings to authenticated;
-- Le passage de « pending » à « active » (modération) se fait par l'administrateur.

-- 5) Commandes et paiements protégés (séquestre)
create table public.orders (
  id          bigint generated always as identity primary key,
  client_id   uuid not null references public.profiles(id),
  total_xaf   integer not null check (total_xaf >= 0),
  status      text not null default 'paid_escrow'
              check (status in ('paid_escrow', 'shipped', 'delivered', 'completed', 'dispute', 'refunded')),
  created_at  timestamptz not null default now()
);
create table public.order_items (
  id          bigint generated always as identity primary key,
  order_id    bigint not null references public.orders(id) on delete cascade,
  listing_id  bigint not null references public.listings(id),
  seller_id   uuid not null references public.profiles(id),
  qty         integer not null default 1 check (qty > 0),
  unit_xaf    integer not null check (unit_xaf >= 0)
);
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
create policy "commandes: le client voit les siennes" on public.orders for select using (client_id = auth.uid());
create policy "lignes: client ou vendeur concerné" on public.order_items for select
  using (seller_id = auth.uid() or exists (select 1 from public.orders o where o.id = order_id and o.client_id = auth.uid()));
-- IMPORTANT : aucune policy d'insertion pour les clients. Les commandes et les changements de statut
-- seront créés par une fonction serveur (Edge Function) APRÈS confirmation du paiement par l'agrégateur.

-- 6) Avis
create table public.reviews (
  id          bigint generated always as identity primary key,
  listing_id  bigint not null references public.listings(id) on delete cascade,
  author_id   uuid not null references public.profiles(id) on delete cascade,
  rating      integer not null check (rating between 1 and 5),
  comment     text,
  created_at  timestamptz not null default now()
);
alter table public.reviews enable row level security;
create policy "avis: tout le monde peut lire" on public.reviews for select using (true);
create policy "avis: écrire en son nom" on public.reviews for insert with check (author_id = auth.uid());
-- À faire : n'autoriser un avis qu'après une commande terminée.
