class UserIngredient < ApplicationRecord
  belongs_to :user
  belongs_to :igredient
end
