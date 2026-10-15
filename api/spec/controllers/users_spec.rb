RSpec.describe UsersController, type: :controller do
  describe "#index" do
    it "returns two users" do
      create_list(:user, 2)

      get :index

      expect(response).to have_http_status(:ok)

      users = JSON.parse(response.body)
      expect(users.size).to eq(2)
    end
  end

  describe "#create" do
    it "creates a user" do
      post :create, params: { user: { name: "John Doe", email: "john.doe@example.com", password: "password" } }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["name"]).to eq("John Doe")
      expect(JSON.parse(response.body)["email"]).to eq("john.doe@example.com")
    end

    it "when the user is not created" do
      post :create, params: { user: { name: "John Doe", email: "john.doe@example.com", password: "password" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to eq("User not created")
    end
  end

  describe "#show" do
    it "returns a user" do
      user = create(:user)

      get :show, params: { id: user.id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq(user.name)
      expect(JSON.parse(response.body)["email"]).to eq(user.email)
    end
  end

  describe "#update" do
    it "updates a user" do
      user = create(:user)

      put :update,
          params: { id: user.id, user: { name: "John Doe", email: "john.doe@example.com", password: "password" } }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("John Doe")
      expect(JSON.parse(response.body)["email"]).to eq("john.doe@example.com")
    end

    it "when user is not found" do
      put :update, params: { id: 999, user: { name: "John Doe", email: "john.doe@example.com", password: "password" } }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "#destroy" do
    it "destroys a user" do
      user = create(:user)

      delete :destroy, params: { id: user.id }

      expect(response).to have_http_status(:no_content)
    end

    it "when user is not found" do
      delete :destroy, params: { id: 999 }

      expect(response).to have_http_status(:not_found)
    end
  end

  # describe "#me" do
  #   it "returns the current user" do
  #     user = create(:user)

  #     get :me, params: { id: user.id }

  #     expect(response).to have_http_status(:ok)
  #     expect(JSON.parse(response.body)["name"]).to eq(user.name)
  #     expect(JSON.parse(response.body)["email"]).to eq(user.email)
  #   end
  # end

  describe "#login" do
    context "when the credentials are valid" do
      it "returns a token" do
        user = create(:user)

        post :login, params: {
          email: user.email,
          password: user.password
        }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["token"]).to be_present
      end
    end

    context "when the credentials are invalid" do
      it "returns unauthorized" do
        post :login, params: {
          email: "incorrect@example.com",
          password: "incorrect"
        }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq("Invalid email or password")
      end
    end
  end

  describe "#logout" do
    it "logs out the user" do
      user = create(:user)

      post :logout, params: { id: user.id }

      expect(response).to have_http_status(:no_content)
    end

    it "when user is not found" do
      post :logout, params: { id: 999 }

      expect(response).to have_http_status(:not_found)
    end
  end
end
