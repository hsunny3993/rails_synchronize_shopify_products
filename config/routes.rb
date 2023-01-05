Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "shopify_auth#login"
  root "products#index"
  post "products/import_json", to: "products#import_json", as: :import_products_from_json
end
