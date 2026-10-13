-- SLSD — schéma de base de données, phase 1 (Supabase / PostgreSQL)
-- Mode d'emploi : dans Supabase, ouvre « SQL Editor », colle ce fichier en entier, puis « Run ».
-- À exécuter UNE SEULE FOIS, sur un projet neuf.
--
-- Règle d'or : SLSD ne détient jamais l'argent. Ici, une commande est seulement ENREGISTRÉE
-- (statut « en_attente_paiement »). Le vrai paiement passera plus tard par un agrégateur agréé
-- (Fapshi ou CamPay), qui seul bloquera et libérera les fonds.

-- =====================================================================
-- 1) Rôles d'utilisateur ('admin' ne peut jamais être choisi à l'inscription)
-- =====================================================================
create type user_role as enum ('client', 'vendeur', 'freelance', 'admin');

-- =====================================================================
-- 2) Profils publics (la « vitrine » : visible par tout le monde)
--    Aucune donnée privée ici : ni téléphone, ni e-mail.
-- =====================================================================
create table public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  full_name   text not null default '' check (char_length(full_name) <= 80),
  role        user_role not null default 'client',
  city        text check (char_length(city) <= 60),
  shop_name   text check (char_length(shop_name) <= 80),  -- nom de boutique (vendeur) ou métier (professionnel)
  verified    boolean not null default false,              -- badge « vérifié » : réservé à l'administrateur
  created_at  timestamptz not null default now()
);
alter table public.profiles enable row level security;
create policy "profil: tout le monde peut voir la vitrine" on public.profiles for select using (true);
create policy "profil: modifier le sien" on public.profiles for update
  using (auth.uid() = id) with check (auth.uid() = id);
-- Personne ne crée ni ne supprime un profil à la main (c'est automatique).
-- Un utilisateur ne peut modifier que ces colonnes (jamais role ni verified) :
revoke insert, update, delete on public.profiles from anon, authenticated;
grant update (full_name, city, shop_name) on public.profiles to authenticated;

-- =====================================================================
-- 3) Données privées (numéro Mobile Money) : visibles par leur seul propriétaire
-- =====================================================================
create table public.profils_prives (
  id     uuid primary key references public.profiles(id) on delete cascade,
  phone  text check (char_length(phone) <= 30)
);
alter table public.profils_prives enable row level security;
create policy "privé: lire le sien" on public.profils_prives for select using (auth.uid() = id);
create policy "privé: modifier le sien" on public.profils_prives for update
  using (auth.uid() = id) with check (auth.uid() = id);
revoke all on public.profils_prives from anon;
revoke insert, update, delete on public.profils_prives from authenticated;
grant update (phone) on public.profils_prives to authenticated;

-- =====================================================================
-- 4) Création automatique du profil à l'inscription
-- =====================================================================
create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
declare r text := new.raw_user_meta_data->>'role';
begin
  insert into public.profiles (id, full_name, role, city, shop_name)
  values (
    new.id,
    left(coalesce(new.raw_user_meta_data->>'full_name', ''), 80),
    case when r in ('client', 'vendeur', 'freelance') then r::user_role else 'client'::user_role end,
    left(new.raw_user_meta_data->>'city', 60),
    left(new.raw_user_meta_data->>'shop_name', 80)
  );
  insert into public.profils_prives (id, phone)
  values (new.id, left(new.raw_user_meta_data->>'phone', 30));
  return new;
end $$;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();

-- =====================================================================
-- 5) Offres (produits, services, profils de professionnels)
--    Une nouvelle offre est « pending » : Giresse la passe à « active » dans
--    Table Editor après vérification. Toute modification la remet en « pending ».
-- =====================================================================
create table public.listings (
  id          bigint generated always as identity primary key,
  owner_id    uuid not null default auth.uid() references public.profiles(id) on delete cascade,
  kind        text not null check (kind in ('produit', 'service', 'talent')),
  univers     text not null check (char_length(univers) <= 60),
  title       text not null check (char_length(title) between 3 and 120),
  description text check (char_length(description) <= 2000),
  price_xaf   integer check (price_xaf between 0 and 1000000000),
  price_label text check (price_label in ('dès', 'sur devis', 'licence')),
  city        text check (char_length(city) <= 60),
  image_url   text check (image_url ~ '^https://' and char_length(image_url) <= 500),
  status      text not null default 'pending' check (status in ('pending', 'active', 'hidden')),
  created_at  timestamptz not null default now(),
  -- Un produit a toujours un prix (il peut aller dans le panier).
  check (kind <> 'produit' or price_xaf is not null)
);
create index listings_status_idx on public.listings (status, created_at desc);
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
create policy "offres: supprimer les siennes" on public.listings for delete
  using (owner_id = auth.uid());
revoke insert, update, delete on public.listings from anon;
revoke update on public.listings from authenticated;
grant update (title, description, price_xaf, price_label, city, image_url) on public.listings to authenticated;
-- (Une offre déjà commandée ne peut pas être supprimée : la base le refuse pour garder l'historique.)

-- Toute modification du contenu par le vendeur renvoie l'offre en validation.
create or replace function public.offre_modifiee() returns trigger
language plpgsql set search_path = public as $$
begin
  if auth.uid() is not null and auth.uid() = old.owner_id
     and (new.title, new.description, new.price_xaf, new.price_label, new.city, new.image_url)
         is distinct from (old.title, old.description, old.price_xaf, old.price_label, old.city, old.image_url) then
    new.status := 'pending';
  end if;
  return new;
end $$;
create trigger listings_revalidation before update on public.listings
  for each row execute function public.offre_modifiee();

-- =====================================================================
-- 6) Commandes (séquestre)
--    Statuts : en_attente_paiement → paye_bloque → livre → valide
--              (ou litige → rembourse / valide)
--    Les clients NE PEUVENT PAS écrire directement dans ces tables : ils passent
--    par la fonction passer_commande() (section 7), qui recalcule les prix.
--    Les changements de statut seront faits plus tard par le serveur, après
--    confirmation de l'agrégateur de paiement.
-- =====================================================================
create table public.orders (
  id          bigint generated always as identity primary key,
  client_id   uuid not null references public.profiles(id),
  total_xaf   integer not null check (total_xaf >= 0),
  status      text not null default 'en_attente_paiement'
              check (status in ('en_attente_paiement', 'paye_bloque', 'livre', 'valide', 'litige', 'rembourse')),
  created_at  timestamptz not null default now()
);
create table public.order_items (
  id          bigint generated always as identity primary key,
  order_id    bigint not null references public.orders(id) on delete cascade,
  listing_id  bigint not null references public.listings(id),
  seller_id   uuid not null references public.profiles(id),
  title       text not null,                        -- titre au moment de l'achat
  qty         integer not null default 1 check (qty between 1 and 99),
  unit_xaf    integer not null check (unit_xaf >= 0)
);
create index order_items_order_idx on public.order_items (order_id);
create index order_items_seller_idx on public.order_items (seller_id);
alter table public.orders enable row level security;
alter table public.order_items enable row level security;

-- Petites fonctions d'aide (elles évitent une boucle infinie entre les deux règles ci-dessous).
create or replace function public.commande_du_client(o bigint) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.orders where id = o and client_id = auth.uid());
$$;
create or replace function public.commande_du_vendeur(o bigint) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.order_items where order_id = o and seller_id = auth.uid());
$$;

create policy "commandes: le client ou un vendeur concerné" on public.orders for select
  using (client_id = auth.uid() or public.commande_du_vendeur(id));
create policy "lignes: le vendeur concerné ou le client" on public.order_items for select
  using (seller_id = auth.uid() or public.commande_du_client(order_id));
revoke insert, update, delete on public.orders from anon, authenticated;
revoke insert, update, delete on public.order_items from anon, authenticated;

-- =====================================================================
-- 7) Passer une commande (sans aucun paiement)
--    Le site envoie seulement : [{"listing_id": 12, "qty": 1}, ...]
--    La base retrouve elle-même le prix et le vendeur : impossible de tricher sur le prix.
-- =====================================================================
create or replace function public.passer_commande(lignes jsonb) returns bigint
language plpgsql security definer set search_path = public as $$
declare
  uid     uuid := auth.uid();
  oid     bigint;
  total   integer := 0;
  ligne   jsonb;
  l       public.listings%rowtype;
  q       integer;
begin
  if uid is null then raise exception 'Connecte-toi pour passer commande.'; end if;
  if jsonb_typeof(lignes) <> 'array' or jsonb_array_length(lignes) = 0 then
    raise exception 'Le panier est vide.';
  end if;
  if jsonb_array_length(lignes) > 50 then raise exception 'Panier trop grand (50 lignes maximum).'; end if;

  insert into public.orders (client_id, total_xaf) values (uid, 0) returning id into oid;

  for ligne in select * from jsonb_array_elements(lignes) loop
    q := coalesce((ligne->>'qty')::integer, 1);
    if q < 1 or q > 99 then raise exception 'Quantité invalide.'; end if;
    select * into l from public.listings where id = (ligne->>'listing_id')::bigint;
    if not found or l.status <> 'active' then raise exception 'Une offre du panier n''est plus disponible.'; end if;
    if l.kind <> 'produit' or l.price_xaf is null then raise exception 'Seuls les produits se commandent au panier.'; end if;
    if l.owner_id = uid then raise exception 'Tu ne peux pas commander ta propre offre.'; end if;
    insert into public.order_items (order_id, listing_id, seller_id, title, qty, unit_xaf)
      values (oid, l.id, l.owner_id, l.title, q, l.price_xaf);
    total := total + q * l.price_xaf;
  end loop;

  update public.orders set total_xaf = total where id = oid;
  return oid;
end $$;
revoke execute on function public.passer_commande(jsonb) from public, anon;
grant execute on function public.passer_commande(jsonb) to authenticated;
revoke execute on function public.commande_du_client(bigint) from public, anon;
revoke execute on function public.commande_du_vendeur(bigint) from public, anon;
grant execute on function public.commande_du_client(bigint) to authenticated;
grant execute on function public.commande_du_vendeur(bigint) to authenticated;

-- =====================================================================
-- 8) Avis : lisibles par tous ; on ne peut noter qu'une offre achetée et validée,
--    une seule fois.
-- =====================================================================
create table public.reviews (
  id          bigint generated always as identity primary key,
  listing_id  bigint not null references public.listings(id) on delete cascade,
  author_id   uuid not null default auth.uid() references public.profiles(id) on delete cascade,
  rating      integer not null check (rating between 1 and 5),
  comment     text check (char_length(comment) <= 1000),
  created_at  timestamptz not null default now(),
  unique (listing_id, author_id)
);
alter table public.reviews enable row level security;
create policy "avis: tout le monde peut lire" on public.reviews for select using (true);
create policy "avis: après une commande validée" on public.reviews for insert
  with check (
    author_id = auth.uid()
    and exists (
      select 1 from public.order_items oi join public.orders o on o.id = oi.order_id
      where oi.listing_id = reviews.listing_id and o.client_id = auth.uid() and o.status = 'valide'
    )
  );
create policy "avis: modifier le sien" on public.reviews for update
  using (author_id = auth.uid()) with check (author_id = auth.uid());
create policy "avis: supprimer le sien" on public.reviews for delete using (author_id = auth.uid());
revoke insert, update, delete on public.reviews from anon;
revoke update on public.reviews from authenticated;
grant update (rating, comment) on public.reviews to authenticated;
