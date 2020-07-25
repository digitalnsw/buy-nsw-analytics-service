module AnalyticsService
  class Engine < ::Rails::Engine
    isolate_namespace AnalyticsService
    config.generators.api_only = true
  end
end
