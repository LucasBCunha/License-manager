require 'rails_helper'

RSpec.describe Accounts::LicenseAssignmentsController, type: :request do
  let(:account) { Account.create!(name: "Test Account") }
  let(:product) { Product.create!(name: "Test Product") }
  let(:subscription) do
    Subscription.create!(
      number_of_licenses: 5,
      account: account,
      product: product,
      issued_at: DateTime.parse('03/01/2025') - 1.day,
      expires_at: DateTime.parse('03/01/2025') + 1.day
    )
  end
  let(:user1) { User.create!(name: "User One", email: "user1@example.com", account: account) }
  let(:user2) { User.create!(name: "User Two", email: "user2@example.com", account: account) }

  before do
    subscription
  end

  describe "GET /accounts/:account_id/license_assignments" do
    it "returns http success" do
      get account_license_assignments_path(account)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /accounts/:account_id/license_assignments/assign" do
    context "when assigning licenses" do
      it "assigns licenses to users and redirects" do
        post assign_account_license_assignments_path(account), params: {
          commit: "assign",
          product_ids: [ product.id ],
          user_ids: [ user1.id, user2.id ]
        }

        expect(response).to redirect_to(account_license_assignments_path(account))
        expect(session[:errors]).to be_nil
        expect(LicenseAssignment.where(account: account, product: product, user: user1).count).to eq(1)
        expect(LicenseAssignment.where(account: account, product: product, user: user2).count).to eq(1)
      end

      it "does not assign licenses if no users or products are selected" do
        post assign_account_license_assignments_path(account), params: {
          commit: "assign",
          product_ids: [],
          user_ids: []
        }

        expect(response).to redirect_to(account_license_assignments_path(account))
        expect(session[:errors]).to include("Please select at least one user and one product.")
      end

      it "handles unassigning licenses" do
        LicenseAssignment.create!(account: account, product: product, user: user1)

        post assign_account_license_assignments_path(account), params: {
          commit: "unassign",
          product_ids: [ product.id ],
          user_ids: [ user1.id ]
        }

        expect(response).to redirect_to(account_license_assignments_path(account))
        expect(session[:errors]).to be_nil
        expect(LicenseAssignment.where(account: account, product: product, user: user1).count).to eq(0)
      end
    end
  end
end
