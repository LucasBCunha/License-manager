require 'rails_helper'

RSpec.describe "Accounts", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/accounts/"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/accounts/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /:id" do
    it "returns http success" do
      account = Account.create!(name: "My Account")
      get "/accounts", params: { id: account.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /" do
    it "returns http success" do
      post "/accounts", params: { account: { name: 'Name' } }
      expect(response).to have_http_status(:redirect)
      expect(Account.count).to eq(1)
    end
  end
end
