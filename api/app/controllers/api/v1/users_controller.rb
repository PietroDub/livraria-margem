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

        if user.save
          render json: user,
                 only: %i[id name email],
                 status: :created
        else
          render json: { errors: user.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password)
      end
    end
  end
end