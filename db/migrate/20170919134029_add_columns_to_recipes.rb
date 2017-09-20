class AddColumnsToRecipes < ActiveRecord::Migration[5.1]
  def change
    add_column :recipes, :source_url, :string
    add_column :recipes, :publisher, :string
    add_column :recipes, :instructions, :text
  end
end
