AnalyticsService::Engine.routes.draw do
  resources :report, only: [:create]
  resources :profile_views, only: [:index]
end
