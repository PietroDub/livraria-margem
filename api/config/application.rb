require_relative 'boot'
require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'rails/test_unit/railtie'
Bundler.require(*Rails.groups)

module Margem
  class Application < Rails::Application
    config.load_defaults 8.1
    config.api_only = true
    config.time_zone = 'Brasilia'
    config.active_record.schema_format = :ruby
    # Em produção, configure um segredo próprio no ambiente.
    config.secret_key_base = ENV.fetch('SECRET_KEY_BASE') { Rails.env.production? ? nil : 'local-learning-only-' * 8 }
  end
end
