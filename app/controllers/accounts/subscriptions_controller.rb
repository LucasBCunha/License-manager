class Accounts::SubscriptionsController < ApplicationController
  before_action :set_account
  before_action :set_product_options, only: [ :new, :create, :edit, :update ]
  before_action :set_subscription, only: [ :edit, :update ]

  def index
    @subscriptions = Subscription.includes(:product).all.limit(100)
  end

  def new
    @subscription = @account.subscriptions.build
  end

  def create
    @subscription = @account.subscriptions.build(subscription_params)
    if @subscription.save
      redirect_to account_subscriptions_path(@account)
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    if @subscription.update(subscription_params)
      redirect_to account_subscriptions_path(@account)
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_account
    @account = Account.find(params[:account_id])
  end

  def set_product_options
    @product_options = Product.limit(100)
  end

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.expect(subscription: [ :product_id, :number_of_licenses, :issued_at, :expires_at ])
  end
end
