require 'rails_helper'

RSpec.describe BatchAssignLicensesService do
  let(:account) { Account.create!(name: "Test Account") }
  let(:product) { Product.create!(name: "Test Product") }
  let(:user1) { User.create!(name: "User One", email: "user1@example.com", account: account) }
  let(:user2) { User.create!(name: "User Two", email: "user2@example.com", account: account) }
  let(:subscription) do
    Subscription.create!(
      number_of_licenses: 2,
      account: account,
      product: product,
      issued_at: DateTime.parse('01/01/2025'),
      expires_at: DateTime.parse('01/12/2025')
    )
  end

  subject { described_class.new }

  describe "#call" do
    context "when enough licenses are available" do
      it "assigns licenses to users" do
        subscription
        result = subject.call(account.id, [ user1.id, user2.id ], [ product.id ])
        expect(result.success?).to be true
        expect(LicenseAssignment.where(account: account, product: product).count).to eq(2)
      end
    end

    context "when not enough licenses are available" do
      let(:user3) { User.create!(name: "User Three", email: "user3@example.com", account: account) }

      before do
        subscription
        LicenseAssignment.create!(account: account, product: product, user: user3)
      end

      it "returns an error" do
        result = subject.call(account.id, [ user1.id, user2.id ], [ product.id ])
        expect(result.success?).to be false
        expect(result.errors).to include(/Not enough licenses/)
      end
    end

    context "when a user already has a license for the product/account combination" do
      before do
        subscription
        LicenseAssignment.create!(account: account, product: product, user: user1)
      end

      it "does not assign additional licenses to the user" do
        result = subject.call(account.id, [ user1.id, user2.id ], [ product.id ])
        expect(result.success?).to be true
        expect(LicenseAssignment.where(account: account, product: product).count).to eq(2)
      end
    end
  end
end
