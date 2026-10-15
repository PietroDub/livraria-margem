module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: %i[update destroy]
      skip_before_action :authenticate_user!, only: %i[create login]

      # GET /api/v1/users
      # Lista todos os usuários ordenados por nome.
      def index
        render json: User.order(:name),
               only: %i[id name email]
      end

      # Referência de estudo: find na action, sem before_action.
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
      # Action pública (skip do filtro). Email/senha no body; token no JSON.
      def login
        # params.dig(:user, :email) é uma sintaxe para acessar um valor aninhado no hash de params.
        # Se o valor não existir, params.dig(:user, :email) retorna nil.
        email = params[:email] || params.dig(:user, :email)
        password = params[:password] || params.dig(:user, :password)
        # Encontra o usuário pelo email.
        user = User.find_by(email: email)

        # Verifica se o usuário existe e a senha é válida.
        if user&.authenticate(password)
          # Gera um token de autenticação válido por 24 horas com o metodo generate.
          token = Rails.application.message_verifier(:authentication).generate(
            { user_id: user.id },
            # Tempo de validade do token em segundos, to_i converte para inteiro.
            expires_in: 24.hours.to_i,
            # O purpose é usado para identificar o tipo de token, nome que escolhemos.
            purpose: :login
          )

          render json: {
            user: user.as_json(only: %i[id name email]),
            token: token
          }
        else
          render json: { error: 'Email ou senha inválidos.' }, status: :unauthorized
        end
      end

      # POST /api/v1/users/logout
      # O filtro já exigiu Bearer válido e preencheu @  current_user.
      # Sem denylist: o cliente descarta o token; o servidor só confirma a sessão.
      def logout
        head :no_content
      end

      def update
        if @user.update(user_params)
          render json: @user, only: %i[id name email], status: :ok
        else
          render json: { errors: @user.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def destroy
        @user.destroy!
        head :no_content
      end

      private

      # Encontra o usuário antes de atualizar ou deletar.
      # Usado em update e destroy.
      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :email, :password)
      end
    end
  end
end
