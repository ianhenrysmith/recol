Recol::Application.routes.draw do
  devise_for :users

  match '/scrape' => 'scrape#index'

  root :to => 'application#index'
end
