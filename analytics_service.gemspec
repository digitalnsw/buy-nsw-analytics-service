$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "analytics_service/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "analytics_service"
  spec.version     = AnalyticsService::VERSION
  spec.authors     = ["Arman"]
  spec.email       = ["arman.zrb@gmail.com"]
  spec.homepage    = ""
  spec.summary     = "Summary of AnalyticsService."
  spec.description = "Description of AnalyticsService."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
end
