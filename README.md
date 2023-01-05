# README

This application synchronizes products from uploaded JSON file with Shopify.

1. User uploads a JSON file to rails app.
2. Uploaded JSON file is stored onto Redis cache store.
3. With Sidekiq, cached JSON data is processed every hour in the background.
4. According to status(active, inactive, deleted), the product was added/updated/deleted.
5. This rails app uses esbuild and sass to import javascript packages and bootstrap.

You can run this app following commands on the root directory.

1. Please set enviroments:
- REDIS_URL=redis://127.0.0.1:6379/0
- RAILS_ENV=development

2. Run this command
bundle install
foreman start -f Procfile
