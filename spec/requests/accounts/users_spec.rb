require 'rails_helper'

RSpec.describe Accounts::UsersController, type: :controller do
  let(:account) { Account.create(name: 'Test Account') }
  let(:user_params) { { user: { name: 'Test User', email: 'test@example.com' } } }

  before do
    @request.env['HTTP_REFERER'] = account_path(account)
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post :create, params: { account_id: account.id }.merge(user_params)
        }.to change(User, :count).by(1)
      end

      it 'redirects to the account page' do
        post :create, params: { account_id: account.id }.merge(user_params)
        expect(response).to redirect_to(account)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a user' do
        invalid_params = { user: { name: '', email: '' } }
        expect {
          post :create, params: { account_id: account.id }.merge(invalid_params)
        }.not_to change(User, :count)
      end

      it 'renders the new template with unprocessable content status' do
        invalid_params = { user: { name: '', email: '' } }
        post :create, params: { account_id: account.id }.merge(invalid_params)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { account.users.create(name: 'Existing User', email: 'existing@example.com') }

    context 'with valid parameters' do
      it 'updates the user' do
        patch :update, params: { account_id: account.id, id: user.id }.merge(user_params)
        user.reload
        expect(user.name).to eq('Test User')
        expect(user.email).to eq('test@example.com')
      end

      it 'redirects to the account page' do
        patch :update, params: { account_id: account.id, id: user.id }.merge(user_params)
        expect(response).to redirect_to(account)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the user' do
        patch :update, params: { account_id: account.id, id: user.id, user: { name: '', email: '' } }
        user.reload
        expect(user.name).to eq('Existing User')
      end

      it 'renders the edit template with unprocessable content status' do
        patch :update, params: { account_id: account.id, id: user.id, user: { name: '', email: '' } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
