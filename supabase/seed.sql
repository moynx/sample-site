-- Run after schema.sql. Persian demo catalog with illustrative prices in toman.
-- The update also translates the earlier English starter rows if those were seeded already.
with sample(original_name,name,category,price,description,image_url,colors,stock,featured,badge) as (
  values
  ('The Sunday Scarf','شال یکشنبه','Scarves',1280000,'ترکیب پشم لطیف · اندازه ۱۹۰ × ۶۵ سانتی‌متر','https://images.unsplash.com/photo-1601924994987-69e26d50dc26?auto=format&fit=crop&w=900&q=85',array['#b4a084','#686b58','#d6cec0']::text[],18,true,'پرفروش'),
  ('Everyday Wrap','شال دورپیچ روزمره','Scarves',1680000,'پنبه‌ی ارگانیک · سبک و خوش‌حالت','https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?auto=format&fit=crop&w=900&q=85',array['#d5c9b7','#8a806f']::text[],12,true,'تازه رسیده'),
  ('Linen Day Shirt','پیراهن لینن روزانه','Clothing',2450000,'پارچه‌ی لینن · برشی آزاد و راحت','https://images.unsplash.com/photo-1598554747436-c9293d6a588f?auto=format&fit=crop&w=900&q=85',array['#e4ded0','#a9aaa0','#685f52']::text[],9,true,''),
  ('Soft Form Tote','کیف پارچه‌ای ساده','Accessories',890000,'برای همراهی هر روز · کتان بازیافتی','https://images.unsplash.com/photo-1590874103328-eac38a683ce7?auto=format&fit=crop&w=900&q=85',array['#c1aa91','#55574a']::text[],23,false,''),
  ('The Field Knit','بافت لطیف فیلد','Clothing',3200000,'ترکیب پنبه و مرینوس · یک لایه‌ی ماندگار','https://images.unsplash.com/photo-1576566588028-4147f3842f27?auto=format&fit=crop&w=900&q=85',array['#c7c2b2','#8d7769']::text[],6,true,'تعداد محدود'),
  ('Little Cloud Bandana','دستمال گردن ابری','Scarves',740000,'وال نخی سبک · ببندش، هر طور که دوست داری','https://images.unsplash.com/photo-1590736969955-71cc94901144?auto=format&fit=crop&w=900&q=85',array['#d7c7b5','#a7a58f','#b57461']::text[],31,false,''),
  ('Weekend Trouser','شلوار راحت آخر هفته','Clothing',2650000,'فرمی راحت و خوش‌دوخت · ترکیب لینن','https://images.unsplash.com/photo-1506629905607-d9c297d6f79c?auto=format&fit=crop&w=900&q=85',array['#c8bda9','#777565']::text[],11,false,''),
  ('Daily Carry Pouch','کیف کوچک روزانه','Accessories',590000,'جایی کوچک برای چیزهای کوچک','https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&w=900&q=85',array['#ad8d74','#76745e']::text[],0,false,'ناموجود')
)
update public.products p set name=s.name,category=s.category,price=s.price,description=s.description,image_url=s.image_url,colors=s.colors,stock=s.stock,featured=s.featured,badge=s.badge
from sample s where p.name=s.original_name or p.name=s.name;

with sample(name,category,price,description,image_url,colors,stock,featured,badge) as (
  values
  ('شال یکشنبه','Scarves',1280000,'ترکیب پشم لطیف · اندازه ۱۹۰ × ۶۵ سانتی‌متر','https://images.unsplash.com/photo-1601924994987-69e26d50dc26?auto=format&fit=crop&w=900&q=85',array['#b4a084','#686b58','#d6cec0']::text[],18,true,'پرفروش'),
  ('شال دورپیچ روزمره','Scarves',1680000,'پنبه‌ی ارگانیک · سبک و خوش‌حالت','https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?auto=format&fit=crop&w=900&q=85',array['#d5c9b7','#8a806f']::text[],12,true,'تازه رسیده'),
  ('پیراهن لینن روزانه','Clothing',2450000,'پارچه‌ی لینن · برشی آزاد و راحت','https://images.unsplash.com/photo-1598554747436-c9293d6a588f?auto=format&fit=crop&w=900&q=85',array['#e4ded0','#a9aaa0','#685f52']::text[],9,true,''),
  ('کیف پارچه‌ای ساده','Accessories',890000,'برای همراهی هر روز · کتان بازیافتی','https://images.unsplash.com/photo-1590874103328-eac38a683ce7?auto=format&fit=crop&w=900&q=85',array['#c1aa91','#55574a']::text[],23,false,''),
  ('بافت لطیف فیلد','Clothing',3200000,'ترکیب پنبه و مرینوس · یک لایه‌ی ماندگار','https://images.unsplash.com/photo-1576566588028-4147f3842f27?auto=format&fit=crop&w=900&q=85',array['#c7c2b2','#8d7769']::text[],6,true,'تعداد محدود'),
  ('دستمال گردن ابری','Scarves',740000,'وال نخی سبک · ببندش، هر طور که دوست داری','https://images.unsplash.com/photo-1590736969955-71cc94901144?auto=format&fit=crop&w=900&q=85',array['#d7c7b5','#a7a58f','#b57461']::text[],31,false,''),
  ('شلوار راحت آخر هفته','Clothing',2650000,'فرمی راحت و خوش‌دوخت · ترکیب لینن','https://images.unsplash.com/photo-1506629905607-d9c297d6f79c?auto=format&fit=crop&w=900&q=85',array['#c8bda9','#777565']::text[],11,false,''),
  ('کیف کوچک روزانه','Accessories',590000,'جایی کوچک برای چیزهای کوچک','https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&w=900&q=85',array['#ad8d74','#76745e']::text[],0,false,'ناموجود')
)
insert into public.products(name,category,price,description,image_url,colors,stock,featured,badge)
select s.name,s.category,s.price,s.description,s.image_url,s.colors,s.stock,s.featured,s.badge from sample s
where not exists(select 1 from public.products p where p.name=s.name);

-- To enable the management panel, create your admin through Supabase Auth first,
-- then run: insert into public.profiles(id,role) values ('AUTH-USER-UUID','admin')
-- on conflict(id) do update set role='admin';

