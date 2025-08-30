class User < ApplicationRecord
  belongs_to :account
  has_many :license_assignments

  validates :email, :name, presence: true
  validates :email, uniqueness: true
end
