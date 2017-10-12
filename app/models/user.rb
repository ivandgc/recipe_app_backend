class User < ApplicationRecord
  has_many :user_ingredients, dependent: :destroy
  has_many :ingredients, through: :user_ingredients, dependent: :destroy
  has_secure_password
end
