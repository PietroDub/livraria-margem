Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.log_level = :info
  config.force_ssl = ENV.fetch('FORCE_SSL', 'true') == 'true'
  config.hosts = ENV.fetch('ALLOWED_HOSTS', 'localhost').split(',')
end
