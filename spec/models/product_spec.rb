require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it 'has many subscriptions' do
      product = Product.reflect_on_association(:subscriptions)
      expect(product.macro).to eq(:has_many)
    end

    it 'has many license assignments' do
      product = Product.reflect_on_association(:license_assignments)
      expect(product.macro).to eq(:has_many)
    end
  end

  describe 'validations' do
    it 'is valid with a name' do
      product = Product.new(name: 'Test Product')
      expect(product).to be_valid
    end

    it 'is invalid without a name' do
      product = Product.new(name: nil)
      expect(product).not_to be_valid
      expect(product.errors[:name]).to include("can't be blank")
    end
  end
end
