# Força o ambiente de teste antes de carregar o Rails.
# `=` e não `||=`: se o Compose já deixou RAILS_ENV=development, `||=` manteria esse valor
# e a spec leria o banco de desenvolvimento. Aqui a spec sempre usa db/test.sqlite3.
ENV['RAILS_ENV'] = 'test'

# Sobe a aplicação (models, controllers, banco) já no ambiente definido acima.
require_relative '../config/environment'
# Trava extra: se mesmo assim o ambiente for produção, interrompe o processo.
abort('Não execute os specs em produção!') if Rails.env.production?
# Liga o RSpec ao Rails: get/post de controller, have_http_status, banco de teste.
require 'rspec/rails'
# create, create_list e authenticate, usados nos exemplos.
require_relative 'support/factory_helpers'

# Bloco de configuração do RSpec. `config` recebe as opções desta suíte.
RSpec.configure do |config|
  # Cada exemplo roda dentro de uma transação desfeita no final.
  # O que o exemplo gravou some. Linhas que já estavam no banco de teste permanecem.
  config.use_transactional_fixtures = true
  # O diretório do arquivo escolhe o tipo: spec/controllers roda como controller.
  config.infer_spec_type_from_file_location!
  # Tira do backtrace os frames internos do Rails, para o erro apontar o exemplo.
  config.filter_rails_from_backtrace!
  # Disponibiliza os métodos de FactoryHelpers em todos os exemplos.
  config.include FactoryHelpers
end
