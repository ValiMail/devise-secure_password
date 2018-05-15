RailsApp514::Application.routes.draw do
  devise_for :users
  root 'static_pages#home'
end
