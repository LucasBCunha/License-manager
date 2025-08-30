class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update]

  def index
    @accounts = Account.all.limit(100).order(:name)
  end

  def show
    @users = User.where(account_id: @account.id).order(:name)
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      redirect_to @account
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    if @account.update(account_params)
      redirect_to @account
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def account_params
    params.expect(account: [ :name ])
  end

  def set_account
    @account = Account.find(params[:id])
  end
end
