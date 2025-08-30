require 'rails_helper'

RSpec.describe BatchUnassignLicensesService do
  let(:account) { Account.create!(name: "Test Account") }
  let(:product) { Product.create!(name: "Test Product") }
  let(:user1) { User.create!(name: "User One", email: "user1@example.com", account: account) }
  let(:user2) { User.create!(name: "User Two", email: "user2@example.com", account: account) }
  let(:user3) { User.create!(name: "User Three", email: "user3@example.com", account: account) }

  before do
    LicenseAssignment.create!(account: account, product: product, user: user1)
    LicenseAssignment.create!(account: account, product: product, user: user2)
    LicenseAssignment.create!(account: account, product: product, user: user3)
  end

  subject { described_class.new }

  describe "#call" do
    context "when unassigning licenses" do
      it "removes the specified licenses for the given users and product" do
        expect {
          result = subject.call(account.id, [ user1.id, user2.id ], [ product.id ])
          expect(result.success?).to be true
          expect(result.executed).to eq(2)
          expect(result.skipped).to eq(0)
        }.to change { LicenseAssignment.count }.by(-2)
      end

      it "does not remove licenses for users not specified" do
        expect {
          subject.call(account.id, [ user1.id ], [ product.id ])
        }.to change { LicenseAssignment.count }.by(-1)

        expect(LicenseAssignment.where(user_id: user2.id, product_id: product.id, account_id: account.id).count).to eq(1)
      end

      it "returns a result with the correct counts" do
        result = subject.call(account.id, [ user1.id, user2.id ], [ product.id ])
        expect(result.executed).to eq(2)
        expect(result.skipped).to eq(0)
      end

      it "returns a result with zero when no licenses are found" do
        result = subject.call(account.id, [ user1.id ], [ Product.create!(name: "Another Product").id ])
        expect(result.executed).to eq(0)
        expect(result.skipped).to eq(0)
      end
    end
  end
end
