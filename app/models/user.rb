class User < ApplicationRecord
  validates :email, presence: true
  has_many :accounts, dependent: :destroy
end
