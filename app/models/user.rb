class User < ApplicationRecord
  belongs_to :account

  validates :email, uniqueness: true
end
