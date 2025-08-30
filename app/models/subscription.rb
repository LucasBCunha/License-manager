class Subscription < ApplicationRecord
  belongs_to :account
  belongs_to :product

  validates :number_of_licenses, numericality: { greater_than: 0 }
  validates :account_id, :product_id, :issued_at, :expires_at, presence: true
end
