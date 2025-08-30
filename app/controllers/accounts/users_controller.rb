class Accounts::UsersController < ApplicationController
  before_action :set_account
  before_action :set_user, only: %i[edit update]

  def new
    @user = @account.users.build
  end

  def create
    @user = @account.users.build(user_params)
    if @user.save
      redirect_to @account
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @account
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_account
    @account = Account.find(params[:account_id])
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.expect(user: [ :name, :email ])
  end
end
