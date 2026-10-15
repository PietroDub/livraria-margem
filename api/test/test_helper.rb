ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActionDispatch::IntegrationTest
  def create_user(name: 'Ana Silva', email: 'ana@example.com', password: 'senha123')
    User.create!(name: name, email: email, password: password)
  end

  def bearer_token_for(user)
    Rails.application.message_verifier(:authentication).generate(
      { user_id: user.id },
      expires_in: 24.hours,
      purpose: :login
    )
  end

  def auth_headers(user)
    { 'Authorization' => "Bearer #{bearer_token_for(user)}" }
  end
end
