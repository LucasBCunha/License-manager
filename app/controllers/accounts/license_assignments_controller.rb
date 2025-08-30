class Accounts::LicenseAssignmentsController < ApplicationController
  before_action :set_account
  before_action :set_products_with_counts

  def index
    @users = @account.users.order(:name)
  end

  def assign
    params.expect!(:commit, product_ids: [], user_ids: [])
    product_ids = params[:product_ids]&.reject(&:blank?)
    user_ids = params[:user_ids]&.reject(&:blank?)

    if user_ids.blank? || product_ids.blank?
      session[:errors] = [ "Please select at least one user and one product." ]
      return redirect_to account_license_assignments_path(@account)
    end

    if params[:commit].downcase == "assign"
      result = ::BatchAssignLicensesService.new.call(@account.id, user_ids, product_ids)
    elsif params[:commit].downcase == "unassign"
      result = ::BatchUnassignLicensesService.new.call(@account.id, user_ids, product_ids)
    end

    if result.success?
      session.delete(:errors)
    else
      session[:errors] = result.errors
    end

    redirect_to account_license_assignments_path(@account)
  end

  private

  def set_products_with_counts
    @products = ::Products::ProductsWithLicenseCountQuery.new.call(@account.id)
  end

  def set_account
    @account = Account.find(params[:account_id])
  end
end
