# AUREL Studio — scarf & clothing shop

A responsive storefront and management panel, designed to run as a static site with a zero-cost demo mode. Supabase adds live catalog, admin authentication, order management, and database-backed checkout. No payment provider is connected: checkout records a pending order for manual confirmation.

## Run locally

From this folder, start any static server, for example:

```sh
npx serve .
```

Open the URL printed by the server. The demo has sample products and sample orders immediately. Catalog changes, order updates, and demo checkout persist in this browser using local storage. Click the small ↗ in the header for the demo management panel.

## Connect a free Supabase project

1. Create a Supabase project.
2. Open the SQL Editor and run `supabase/schema.sql`, followed by `supabase/seed.sql`.
3. Copy the Project URL and publishable/anon key from **Project Settings → API** into `config.js`.
4. In **Authentication → Users**, create your studio user. Copy its UUID and run the admin profile statement shown at the bottom of `supabase/seed.sql`.
5. Open `index.html` through a static web host or a local static server. Studio login is available from ↗.

Only the public anon key belongs in browser configuration; never expose a service-role key. The SQL grants public catalog reads and uses row-level security for studio data. Checkout uses a database function that calculates totals from current prices and reserves inventory atomically. Orders remain unpaid until you arrange payment with the customer.

## Publish the scripts on GitHub

This folder is ready to commit. Create a free GitHub repository, then run:

```sh
git init
git add .
git commit -m "Build AUREL Studio shop"
git branch -M main
git remote add origin https://github.com/YOUR-ACCOUNT/YOUR-REPOSITORY.git
git push -u origin main
```

The static storefront can be published from GitHub Pages. Use a separate deployment secret/build step for Supabase settings if you prefer not to commit the public project URL and anon key. The anon key is designed for client use; access control is enforced by the SQL policies.

## Included management features

- Overview for sales totals, order count, active catalog, and low stock
- Product create, edit, delete, visibility, category, pricing, image, and stock
- Order search, status updates, and customer/order summaries
- Inventory totals, stock value, sold-out and low-stock tracking
- Responsive storefront search, category filtering, sorting, shopping bag, and checkout

Before live sales, add a payment processor and confirm tax, shipping, privacy, and returns settings for your business.

