Rails.application.routes.draw do
  resources :events
  resources :categories
  resources :users

  get '/events/:id/attendees', to: 'events#attendees'
  post '/events/:id/attendees', to: 'events#add_attendee'
  get '/users/:id/events', to: 'users#events'
  get '/categories/:id/events', to: 'categories#events'
  get '/categories/:id/subcategories', to: 'categories#subcategories'
  post '/authenticate', to: 'authentication#authenticate'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
