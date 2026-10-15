# Pai dos controllers da API. ::API é a base JSON do Rails (sem views HTML).
# rescue_from: se a exception estourar numa action filha, este bloco responde.
class ApplicationController < ActionController::API
  # Autentica o usuário antes de executar a action.
  before_action :authenticate_user!
  # User.find / Book.find com id inexistente.
  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'Objeto não encontrado.' }, status: :not_found
  end
  # params.require(:user) ou :book quando o envelope não veio no body.
  rescue_from ActionController::ParameterMissing do |exception|
    render json: { error: "Parâmetro obrigatório ausente: #{exception.param}." }, status: :bad_request
  end
  # Unique do banco (ISBN/email) quando a validação do model não pegou.
  rescue_from ActiveRecord::RecordNotUnique do
    render json: { errors: ['Este Identificador já está cadastrado.'] }, status: :unprocessable_entity
  end

  private
  def authenticate_user!
    header = request.headers['Authorization']
    token = header&.delete_prefix('Bearer ')&.strip
    if token.blank?
      render json: { error: 'Não autenticado.' }, status: :unauthorized
      return
    end

    payload = Rails.application.message_verifier(:authentication).verify(token, purpose: :login)
    @current_user = User.find(payload['user_id'] || payload[:user_id])
  rescue ActiveSupport::MessageVerifier::InvalidSignature, ActiveRecord::RecordNotFound
    render json: { error: 'Não autenticado.' }, status: :unauthorized
  end
end
