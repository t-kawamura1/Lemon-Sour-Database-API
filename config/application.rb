require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    config.load_defaults 6.0
    config.time_zone = ENV["TZ"]
    config.active_record.default_timezone = :utc
    config.beginning_of_week = :monday
    config.i18n.default_locale = :ja
    config.add_autoload_paths_to_load_path = false
    config.api_only = true

    config.generators do |g|
      g.test_framework :rspec,
        view_specs: false,
        helper_specs: false,
        routing_specs: false
    end

    config.middleware.use ActionDispatch::Flash
    config.session_store :cookie_store
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore, config.session_options
    config.middleware.use ::Rack::MethodOverride
  end
end
