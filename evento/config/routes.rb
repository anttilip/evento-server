Rails.application.routes.draw do
  resources :events
  resources :categories
  resources :users

  get '/events/:id/attendees', to: 'events#attendees'
  get '/users/:id/events', to: 'users#events'
  get '/categories/:id/events', to: 'categories#events'
  get '/categories/:id/subcategories', to: 'categories#subcategories'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
