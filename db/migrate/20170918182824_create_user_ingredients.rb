class CreateUserIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :user_ingredients do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :ingredient, foreign_key: true

      t.timestamps
    end
  end
end
