Rspec.describe BooksController, type: :controller do
  describe "#index" do
    it "returns a list of books" do
      get :index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["books"]).to be_present
    end

    it "when the books are not found" do
      get :index

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Books not found")
    end
  end

  describe "#show" do
    it "returns a book" do
      book = create(:book)

      get :show, params: { id: book.id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["title"]).to eq(book.title)
    end

    it "when the book is not found" do
      get :show, params: { id: 999 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Book not found")
    end
  end

  describe "#create" do
    it "creates a book" do
      post :create, params: { book: { title: "The Great Gatsby", author: "F. Scott Fitzgerald" } }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["title"]).to eq("The Great Gatsby")
      expect(JSON.parse(response.body)["author"]).to eq("F. Scott Fitzgerald")
    end
  end

  describe "#update" do
    it "updates a book" do
      book = create(:book)

      put :update, params: { id: book.id, book: { title: "The Great Gatsby", author: "F. Scott Fitzgerald" } }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["title"]).to eq("The Great Gatsby")
      expect(JSON.parse(response.body)["author"]).to eq("F. Scott Fitzgerald")
    end

    it "when the book is not found" do
      put :update, params: { id: 999, book: { title: "The Great Gatsby", author: "F. Scott Fitzgerald" } }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Book not found")
    end
  end

  describe "#destroy" do
    it "destroys a book" do
      book = create(:book)

      delete :destroy, params: { id: book.id }

      expect(response).to have_http_status(:no_content)
    end

    it "when the book is not found" do
      delete :destroy, params: { id: 999 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Book not found")
    end
  end
end
