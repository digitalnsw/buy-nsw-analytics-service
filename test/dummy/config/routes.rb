Rails.application.routes.draw do
  mount AnalyticsService::Engine => "/analytics_service"
end
