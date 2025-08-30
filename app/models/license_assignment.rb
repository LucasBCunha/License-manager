class LicenseAssignment < ApplicationRecord
  belongs_to :account
  belongs_to :user
  belongs_to :product

  validates :user_id, uniqueness: { scope: [ :account_id, :product_id ],
    message: lambda { |object, _data| "\'#{object.user.name}\' already has license for #{object.product.name}" } }
end
