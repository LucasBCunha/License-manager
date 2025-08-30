require 'rails_helper'

RSpec.describe Products::ProductsWithLicenseCountQuery do
  let(:account) { Account.create!(name: "Test Account") }
  let(:user1) { User.create!(name: "User 1", email: "email1@email.com", account:) }
  let(:user2) { User.create!(name: "User 2", email: "email2@email.com", account:) }
  let(:product1) { Product.create!(name: "Product One") }
  let(:product2) { Product.create!(name: "Product Two") }
  let(:subscription1) do
    Subscription.create!(
      number_of_licenses: 5,
      account: account,
      product: product1,
      issued_at: DateTime.parse('01/01/2025'),
      expires_at: DateTime.parse('01/12/2025')
    )
  end
  let(:subscription2) do
    Subscription.create!(
      number_of_licenses: 3,
      account: account,
      product: product2,
      issued_at: DateTime.parse('01/01/2025'),
      expires_at: DateTime.parse('01/12/2025')
    )
  end

  before do
    subscription1
    subscription2
  end

  describe '#call' do
    context 'when there are license assignments' do
      before do
        LicenseAssignment.create!(product: product1, user: user1, account:)
        LicenseAssignment.create!(product: product1, user: user2, account:)
        LicenseAssignment.create!(product: product2, user: user1, account:)
      end

      it 'returns the correct consumed and available licenses for each product' do
        result = described_class.new.call(account.id)

        expect(result).to match_array([
          have_attributes(
            id: product1.id,
            consumed_licenses: 2,
            available_licenses: 5
          ),
          have_attributes(
            id: product2.id,
            consumed_licenses: 1,
            available_licenses: 3
          )
        ])
      end
    end

    context 'when there are no license assignments' do
      it 'returns the correct available licenses with zero consumed licenses' do
        result = described_class.new.call(account.id)

        expect(result).to match_array([
          have_attributes(
            id: product1.id,
            consumed_licenses: 0,
            available_licenses: 5
          ),
          have_attributes(
            id: product2.id,
            consumed_licenses: 0,
            available_licenses: 3
          )
        ])
      end
    end
  end
end
