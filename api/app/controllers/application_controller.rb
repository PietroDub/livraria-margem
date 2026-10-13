class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'Livro não encontrado.' }, status: :not_found
  end
  rescue_from ActionController::ParameterMissing do |exception|
    render json: { error: "Parâmetro obrigatório ausente: #{exception.param}." }, status: :bad_request
  end
  rescue_from ActiveRecord::RecordNotUnique do
    render json: { errors: ['Este ISBN já está cadastrado.'] }, status: :unprocessable_entity
  end
end
