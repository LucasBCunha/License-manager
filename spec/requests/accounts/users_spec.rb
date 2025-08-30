require 'rails_helper'

RSpec.describe "Accounts::Users", type: :request do
  let(:account) { Account.create(name: 'Test Account') }
  let(:valid_attributes) do
    {
      user: {
        name: 'Test User',
        email: 'test@example.com'
      }
    }
  end

  let(:invalid_attributes) do
    {
      user: {
        name: '',
        email: ''
      }
    }
  end

  describe "GET /accounts/:account_id/users/new" do
    it "returns http success" do
      get new_account_user_path(account)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /accounts/:account_id/users" do
    context "with valid attributes" do
      it "creates a new user" do
        expect {
          post account_users_path(account), params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it "redirects to the account page" do
        post account_users_path(account), params: valid_attributes
        expect(response).to redirect_to(account)
      end
    end

    context "with invalid attributes" do
      it "does not create a new user" do
        expect {
          post account_users_path(account), params: invalid_attributes
        }.not_to change(User, :count)
      end

      it "renders the new template with unprocessable content status" do
        post account_users_path(account), params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "GET /accounts/:account_id/users/:id/edit" do
    let!(:user) { account.users.create(valid_attributes[:user]) }

    it "returns http success" do
      get edit_account_user_path(account, user)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /accounts/:account_id/users/:id" do
    let!(:user) { account.users.create(valid_attributes[:user]) }

    context "with valid attributes" do
      it "updates the user" do
        patch account_user_path(account, user), params: { user: { name: 'Updated User' } }
        user.reload
        expect(user.name).to eq('Updated User')
      end

      it "redirects to the account page" do
        patch account_user_path(account, user), params: { user: { name: 'Updated User' } }
        expect(response).to redirect_to(account)
      end
    end

    context "with invalid attributes" do
      it "does not update the user" do
        old_name = user.name
        patch account_user_path(account, user), params: { user: { name: '' } }
        user.reload
        expect(user.name).to eq(old_name)
      end

      it "renders the edit template with unprocessable content status" do
        patch account_user_path(account, user), params: { user: { name: '' } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
