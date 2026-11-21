-- AUREL Studio shop schema. Run in Supabase SQL Editor as project owner.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role text not null default 'customer' check (role in ('admin','customer')),
  created_at timestamptz not null default now()
);

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public
as $$ select exists(select 1 from public.profiles where id = auth.uid() and role = 'admin') $$;

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text not null check (category in ('Scarves','Clothing','Accessories')),
  price numeric(10,2) not null check (price >= 0),
  description text not null default '',
  image_url text not null default '',
  colors text[] not null default '{}',
  stock integer not null default 0 check (stock >= 0),
  featured boolean not null default false,
  badge text not null default '',
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  customer_name text not null,
  email text not null,
  address text not null,
  city text not null,
  postal text not null,
  note text not null default '',
  status text not null default 'pending' check (status in ('pending','processing','shipped','delivered','cancelled','refunded')),
  total numeric(10,2) not null default 0 check (total >= 0),
  created_at timestamptz not null default now()
);

create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  product_id uuid references public.products(id) on delete set null,
  product_name text not null,
  unit_price numeric(10,2) not null check (unit_price >= 0),
  quantity integer not null check (quantity > 0),
  created_at timestamptz not null default now()
);

create index if not exists products_active_category_idx on public.products(active,category);
create index if not exists orders_created_at_idx on public.orders(created_at desc);
create index if not exists order_items_order_id_idx on public.order_items(order_id);

alter table public.profiles enable row level security;
alter table public.products enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;

drop policy if exists "Admins manage profiles" on public.profiles;
create policy "Admins manage profiles" on public.profiles for select to authenticated using (public.is_admin());
drop policy if exists "Public can view active products" on public.products;
create policy "Public can view active products" on public.products for select to anon, authenticated using (active = true or public.is_admin());
drop policy if exists "Admins manage products" on public.products;
create policy "Admins manage products" on public.products for all to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "Admins manage orders" on public.orders;
create policy "Admins manage orders" on public.orders for all to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "Admins view order items" on public.order_items;
create policy "Admins view order items" on public.order_items for select to authenticated using (public.is_admin());

-- Atomic public order creation. Prices and stock are read from the database, not trusted from the browser.
create or replace function public.checkout_order(customer jsonb, items jsonb)
returns uuid language plpgsql security definer set search_path = public
as $$
declare
  new_order_id uuid;
  calculated_total numeric(10,2) := 0;
  row_item jsonb;
  product_row public.products%rowtype;
  item_qty integer;
begin
  if jsonb_typeof(items) <> 'array' or jsonb_array_length(items) = 0 or jsonb_array_length(items) > 50 then
    raise exception 'Your bag is empty or too large.';
  end if;
  if coalesce(trim(customer->>'name'),'') = '' or coalesce(trim(customer->>'email'),'') = ''
    or coalesce(trim(customer->>'address'),'') = '' or coalesce(trim(customer->>'city'),'') = ''
    or coalesce(trim(customer->>'postal'),'') = '' then raise exception 'Please complete the delivery details.'; end if;
  for row_item in select * from jsonb_array_elements(items) loop
    item_qty := (row_item->>'quantity')::integer;
    if item_qty < 1 or item_qty > 25 then raise exception 'Invalid item quantity.'; end if;
    select * into product_row from public.products where id = (row_item->>'product_id')::uuid and active = true for update;
    if not found or product_row.stock < item_qty then raise exception 'A selected piece is no longer available in that quantity.'; end if;
    calculated_total := calculated_total + product_row.price * item_qty;
  end loop;
  insert into public.orders(customer_name,email,address,city,postal,note,total)
    values(trim(customer->>'name'),trim(customer->>'email'),trim(customer->>'address'),trim(customer->>'city'),trim(customer->>'postal'),coalesce(customer->>'note',''),calculated_total)
    returning id into new_order_id;
  for row_item in select * from jsonb_array_elements(items) loop
    item_qty := (row_item->>'quantity')::integer;
    select * into product_row from public.products where id = (row_item->>'product_id')::uuid for update;
    insert into public.order_items(order_id,product_id,product_name,unit_price,quantity)
      values(new_order_id,product_row.id,product_row.name,product_row.price,item_qty);
    update public.products set stock = stock - item_qty where id = product_row.id;
  end loop;
  return new_order_id;
end;
$$;
revoke all on function public.checkout_order(jsonb,jsonb) from public;
grant execute on function public.checkout_order(jsonb,jsonb) to anon, authenticated;

grant select on public.products to anon, authenticated;
grant all on public.products to authenticated;
grant select, update on public.orders to authenticated;
grant select on public.order_items to authenticated;
grant select on public.profiles to authenticated;

