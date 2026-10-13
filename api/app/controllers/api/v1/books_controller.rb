module Api
  module V1
    class BooksController < ApplicationController
      before_action :set_book, only: %i[show update destroy]

      # GET /api/v1/books
      def index
        render json: Book.alphabetical
      end

      # GET /api/v1/books/:id
      def show
        render json: @book
      end

      # POST /api/v1/books
      def create
        book = Book.new(book_params)
        if book.save
          render json: book, status: :created
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
