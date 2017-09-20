class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :recipe_id
      t.string :image_url
      t.integer :rating

      t.timestamps
    end
  end
end
