Rails.application.routes.draw do
  resources :events
  resources :categories
  resources :users

  get '/events/:id/attendees', to: 'events#attendees'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
