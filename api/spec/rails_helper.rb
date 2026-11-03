ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'
abort('Não execute os specs em produção!') if Rails.env.production?
require 'rspec/rails'
require_relative 'support/factory_helpers'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryHelpers
end
