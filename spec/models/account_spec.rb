require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'associations' do
    it 'has many users' do
      account = Account.reflect_on_association(:users)
      expect(account.macro).to eq(:has_many)
    end

    it 'has many subscriptions' do
      account = Account.reflect_on_association(:subscriptions)
      expect(account.macro).to eq(:has_many)
    end

    it 'has many license assignments' do
      account = Account.reflect_on_association(:license_assignments)
      expect(account.macro).to eq(:has_many)
    end
  end

  describe 'validations' do
    it 'is valid with a name' do
      account = Account.new(name: 'Test Account')
      expect(account).to be_valid
    end

    it 'is invalid without a name' do
      account = Account.new(name: nil)
      expect(account).not_to be_valid
      expect(account.errors[:name]).to include("can't be blank")
    end
  end
end
