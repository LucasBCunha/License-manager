class Product < ApplicationRecord
  has_many :subscriptions
  has_many :license_assignments

  validates :name, presence: true
end
