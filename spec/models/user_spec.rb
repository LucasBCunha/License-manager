require 'rails_helper'

RSpec.describe User, type: :model do
  let(:account) { Account.create!(name: "Test Account") }

  describe 'validations' do
    it 'email must be unique' do
      User.create!(email: 'test@example.com', name: 'User1', account: account)
      user2 = User.new(email: 'test@example.com', name: 'User2', account: account)
      expect(user2).not_to be_valid
      expect(user2.errors[:email]).to include('has already been taken')
    end
  end
end
