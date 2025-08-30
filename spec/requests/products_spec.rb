require 'rails_helper'

RSpec.describe "Products", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/products/"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      product = Product.create!(name: 'Product')
      get "/products/", params: { id: product.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/products/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /" do
    it "returns http success" do
      post "/products", params: { product: { name: 'Name' } }
      expect(response).to have_http_status(:redirect)
      expect(Product.count).to eq(1)
    end
  end
end
