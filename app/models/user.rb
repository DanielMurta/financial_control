class User < ApplicationRecord
  has_many :accounts, dependent: :destroy
end
