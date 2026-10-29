module Api
  module V1
    class BooksController < ApplicationController
      before_action :set_book, only: %i[show update destroy]
      skip_before_action :authenticate_user!, only: %i[index show]

      # GET /api/v1/books
      def index
        @books = Book.alphabetical.page params[:page]
        render formats: :json
      end

      # GET /api/v1/books/:id
      def show
        # Renderiza o template show.json.jbuilder desta action.
        # `formats: :json` pede explicitamente o formato JSON nesta API-only app.
        @book = Book.find(params[:id])
        render formats: :json
      end

      # POST /api/v1/books
      def create
        book = Book.new(book_params)
        if book.save
          render formats: :json, status: :created
        else
          render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/books/:id
      def update
        if @book.update(book_params)
          render json: @book
        else
          render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/books/:id
      def destroy
        @book.destroy!
        head :no_content
      end

      private

      def set_book
        @book = Book.find(params[:id])
      end

      def book_params
        params.require(:book).permit(:title, :author, :category, :isbn, :price_cents, :stock, :description)
      end
    end
  end
end
