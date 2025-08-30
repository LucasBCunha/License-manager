require 'rails_helper'

RSpec.describe LicenseAssignment, type: :model do
  let(:account) { Account.create!(name: "Test Account") }
  let(:user) { User.create!(name: "Test User", email: "test@example.com", account: account) }
  let(:product) { Product.create!(name: "Test Product") }

  describe 'associations' do
    it 'belongs to an account' do
      license_assignment = LicenseAssignment.reflect_on_association(:account)
      expect(license_assignment.macro).to eq(:belongs_to)
    end

    it 'belongs to a user' do
      license_assignment = LicenseAssignment.reflect_on_association(:user)
      expect(license_assignment.macro).to eq(:belongs_to)
    end

    it 'belongs to a product' do
      license_assignment = LicenseAssignment.reflect_on_association(:product)
      expect(license_assignment.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    context 'when creating a new license assignment' do
      it 'is valid with unique user, account, and product combination' do
        license_assignment = LicenseAssignment.new(user: user, account: account, product: product)
        expect(license_assignment).to be_valid
      end

      it 'is invalid with a duplicate license assignment for the same user, account, and product' do
        LicenseAssignment.create!(user: user, account: account, product: product)
        duplicate_assignment = LicenseAssignment.new(user: user, account: account, product: product)

        expect(duplicate_assignment).not_to be_valid
        expect(duplicate_assignment.errors[:user_id]).to include("'#{user.name}' already has license for #{product.name}")
      end
    end
  end
end
