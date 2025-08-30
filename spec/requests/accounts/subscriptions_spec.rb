require 'rails_helper'

RSpec.describe "Accounts::Subscriptions", type: :request do
  let(:account) { Account.create(name: 'Test Account') }
  let(:product) { Product.create(name: 'Test Product') }
  let(:valid_attributes) do
    {
      subscription: {
        product_id: product.id,
        number_of_licenses: 5,
        issued_at: Date.today,
        expires_at: Date.today + 30
      }
    }
  end

  let(:invalid_attributes) do
    {
      subscription: {
        product_id: nil,
        number_of_licenses: 0,
        issued_at: nil,
        expires_at: nil
      }
    }
  end

  describe "GET /accounts/:account_id/subscriptions" do
    it "returns http success" do
      get account_subscriptions_path(account)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /accounts/:account_id/subscriptions/new" do
    it "returns http success" do
      get new_account_subscription_path(account)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /accounts/:account_id/subscriptions" do
    context "with valid attributes" do
      it "creates a new subscription" do
        expect {
          post account_subscriptions_path(account), params: valid_attributes
        }.to change(Subscription, :count).by(1)
      end

      it "redirects to the subscriptions index" do
        post account_subscriptions_path(account), params: valid_attributes
        expect(response).to redirect_to(account_subscriptions_path(account))
      end
    end

    context "with invalid attributes" do
      it "does not create a new subscription" do
        expect {
          post account_subscriptions_path(account), params: invalid_attributes
        }.not_to change(Subscription, :count)
      end

      it "renders the new template with unprocessable content status" do
        post account_subscriptions_path(account), params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "GET /accounts/:account_id/subscriptions/:id/edit" do
    let!(:subscription) { account.subscriptions.create(valid_attributes[:subscription]) }

    it "returns http success" do
      get edit_account_subscription_path(account, subscription)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /accounts/:account_id/subscriptions/:id" do
    let!(:subscription) { account.subscriptions.create(valid_attributes[:subscription]) }

    context "with valid attributes" do
      it "updates the subscription" do
        patch account_subscription_path(account, subscription), params: { subscription: { number_of_licenses: 10 } }
        subscription.reload
        expect(subscription.number_of_licenses).to eq(10)
      end

      it "redirects to the subscriptions index" do
        patch account_subscription_path(account, subscription), params: { subscription: { number_of_licenses: 10 } }
        expect(response).to redirect_to(account_subscriptions_path(account))
      end
    end

    context "with invalid attributes" do
      it "does not update the subscription" do
        old_value = subscription.number_of_licenses
        patch account_subscription_path(account, subscription), params: { subscription: { number_of_licenses: 0 } }
        expect(subscription.reload.number_of_licenses).to eq(old_value)
      end

      it "renders the edit template with unprocessable content status" do
        patch account_subscription_path(account, subscription), params: { subscription: { number_of_licenses: 0 } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
