-- Run after schema.sql. Sample storefront catalog; the insert is repeatable by name.
insert into public.products(name,category,price,description,image_url,colors,stock,featured,badge)
select x.name,x.category,x.price,x.description,x.image_url,x.colors,x.stock,x.featured,x.badge
from (values
 ('The Sunday Scarf','Scarves',68.00,'Soft brushed wool blend · 190 × 65 cm','https://images.unsplash.com/photo-1601924994987-69e26d50dc26?auto=format&fit=crop&w=900&q=85',array['#b4a084','#686b58','#d6cec0']::text[],18,true,'Bestseller'),
 ('Everyday Wrap','Scarves',84.00,'Organic cotton and a little room to breathe','https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?auto=format&fit=crop&w=900&q=85',array['#d5c9b7','#8a806f']::text[],12,true,'New'),
 ('Linen Day Shirt','Clothing',112.00,'Relaxed linen · Easy, all-day shape','https://images.unsplash.com/photo-1598554747436-c9293d6a588f?auto=format&fit=crop&w=900&q=85',array['#e4ded0','#a9aaa0','#685f52']::text[],9,true,''),
 ('Soft Form Tote','Accessories',46.00,'Everyday carry · Recycled canvas','https://images.unsplash.com/photo-1590874103328-eac38a683ce7?auto=format&fit=crop&w=900&q=85',array['#c1aa91','#55574a']::text[],23,false,''),
 ('The Field Knit','Clothing',148.00,'Cotton and merino · A forever layer','https://images.unsplash.com/photo-1576566588028-4147f3842f27?auto=format&fit=crop&w=900&q=85',array['#c7c2b2','#8d7769']::text[],6,true,'Low stock'),
 ('Little Cloud Bandana','Scarves',38.00,'Lightweight cotton voile · Made to tie your way','https://images.unsplash.com/photo-1590736969955-71cc94901144?auto=format&fit=crop&w=900&q=85',array['#d7c7b5','#a7a58f','#b57461']::text[],31,false,''),
 ('Weekend Trouser','Clothing',126.00,'A softer structure · Linen blend','https://images.unsplash.com/photo-1506629905607-d9c297d6f79c?auto=format&fit=crop&w=900&q=85',array['#c8bda9','#777565']::text[],11,false,''),
 ('Daily Carry Pouch','Accessories',32.00,'A small place for the little things','https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&w=900&q=85',array['#ad8d74','#76745e']::text[],0,false,'Sold out')
) as x(name,category,price,description,image_url,colors,stock,featured,badge)
where not exists(select 1 from public.products p where p.name=x.name);

-- To enable the management panel, create your admin through Supabase Auth first,
-- then run: insert into public.profiles(id,role) values ('AUTH-USER-UUID','admin')
-- on conflict(id) do update set role='admin';

