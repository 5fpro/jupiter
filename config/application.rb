require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Jupiter
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.action_mailer.delivery_method = :aws_sdk

    # disable some file generators
    config.generators.stylesheets = false
    config.generators.javascripts = false
    config.generators.helper = false
    config.generators.helper_specs = false
    # factory girl rails
    config.generators do |g|
      g.test_framework :rspec, fixture: true, views: false, fixture_replacement: :factory_girl
      g.factory_girl dir: "spec/factories"
    end

    # serve error pages from the Rails app itself (routes.rb)
    config.exceptions_app = self.routes

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Taipei'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.active_job.queue_adapter = :sidekiq
  end
end
