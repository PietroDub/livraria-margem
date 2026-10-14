module Api
  module V1
    class UsersController < ApplicationController
      def index
        render json: User.order(:name),
               only: %i[id name email]
      end

      def show
        user = User.find(params[:id])

        render json: user,
               only: %i[id name email]
      end

      def create
        user = User.new(user_params)

        # save valida o usuário e, com has_secure_password, gera o hash
        # da senha para password_digest antes de gravar.
        if user.save
          render json: user,
                 only: %i[id name email],
                 status: :created
        else
          render json: { errors: user.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      # POST /api/v1/users/login
      # Espera email e password no corpo da requisição.
      def login
        user = User.find_by(email: params[:email])

        # authenticate compara a senha recebida com o hash password_digest.
        # &. evita chamar authenticate se nenhum usuário corresponder ao email.
        if user&.authenticate(params[:password])
          render json: user, only: %i[id name email]
        else
          # A mensagem é igual para email desconhecido e senha incorreta.
          render json: { error: 'Email ou senha inválidos.' }, status: :unauthorized
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password)
      end
    end
  end
end
