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
    let(:active_subscription) do
      Subscription.create!(
        number_of_licenses: 5,
        account: account,
        product: product,
        issued_at: DateTime.parse('03/01/2025') - 1.day,
        expires_at: DateTime.parse('03/01/2025') + 1.day
      )
    end

    it 'is valid with valid attributes' do
      subscription = Subscription.new(
        account: account,
        product: product,
        number_of_licenses: 5,
        issued_at: DateTime.parse('03/01/2025'),
        expires_at: DateTime.parse('03/01/2025') + 30
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

    it 'is valid outside of interval active subscription' do
      active_subscription
      new_subscription = Subscription.new(
        number_of_licenses: 3,
        account: account,
        product: product,
        issued_at: active_subscription.expires_at + 1.hour,
        expires_at: active_subscription.expires_at + 30.days
      )
      expect(new_subscription).to be_valid
    end

    it 'is invalid with an active subscription for the same account and product' do
      active_subscription
      invalid_subscription = Subscription.new(
        number_of_licenses: 2,
        account: account,
        product: product,
        issued_at: active_subscription.issued_at - 2.days,
        expires_at: active_subscription.issued_at + 2.days
      )
      expect(invalid_subscription).not_to be_valid
      expect(invalid_subscription.errors[:base]).to include("Only one active subscription is allowed for this account and product.")
    end
  end
end
