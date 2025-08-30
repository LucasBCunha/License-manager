class Subscription < ApplicationRecord
  belongs_to :account
  belongs_to :product

  validates :number_of_licenses, numericality: { greater_than: 0 }
  validates :account_id, :product_id, :issued_at, :expires_at, presence: true
  validates :expires_at, comparison: { greater_than: :issued_at }
  validate :only_one_active_subscription

  private

  def only_one_active_subscription
    if Subscription.where(account_id: account_id, product_id: product_id)
        .where("(issued_at, expires_at) overlaps (?, ?)", issued_at, expires_at)
        .exists?
      errors.add(:base, "Only one active subscription is allowed for this account and product.")
    end
  end
end
