require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:account) { Account.create(name: 'Test Account') }
  let(:product) { Product.create(name: 'Test Product') }

  describe 'associations' do
    it 'belongs to an account' do
      subscription = Subscription.reflect_on_association(:account)
      expect(subscription.macro).to eq(:belongs_to)
    end

    it 'belongs to a product' do
      subscription = Subscription.reflect_on_association(:product)
      expect(subscription.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      subscription = Subscription.new(
        account: account,
        product: product,
        number_of_licenses: 5,
        issued_at: Date.today,
        expires_at: Date.today + 30
      )
      expect(subscription).to be_valid
    end

    it 'is invalid without an account_id' do
      subscription = Subscription.new(account: nil, product: product, number_of_licenses: 5, issued_at: Date.today, expires_at: Date.today + 30)
      expect(subscription).not_to be_valid
      expect(subscription.errors[:account]).to include("must exist")
    end

    it 'is invalid without a product_id' do
      subscription = Subscription.new(account: account, product: nil, number_of_licenses: 5, issued_at: Date.today, expires_at: Date.today + 30)
      expect(subscription).not_to be_valid
      expect(subscription.errors[:product]).to include("must exist")
    end

    it 'is invalid without an issued_at date' do
      subscription = Subscription.new(account: account, product: product, number_of_licenses: 5, issued_at: nil, expires_at: Date.today + 30)
      expect(subscription).not_to be_valid
      expect(subscription.errors[:issued_at]).to include("can't be blank")
    end

    it 'is invalid without an expires_at date' do
      subscription = Subscription.new(account: account, product: product, number_of_licenses: 5, issued_at: Date.today, expires_at: nil)
      expect(subscription).not_to be_valid
      expect(subscription.errors[:expires_at]).to include("can't be blank")
    end

    it 'is invalid with number_of_licenses less than or equal to 0' do
      subscription = Subscription.new(account: account, product: product, number_of_licenses: 0, issued_at: Date.today, expires_at: Date.today + 30)
      expect(subscription).not_to be_valid
      expect(subscription.errors[:number_of_licenses]).to include("must be greater than 0")
    end
  end
end
