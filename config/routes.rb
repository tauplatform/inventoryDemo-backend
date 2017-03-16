Rails.application.routes.draw do
  resources :inventory_items
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'inventory_items#index'
end
