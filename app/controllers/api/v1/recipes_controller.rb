class Api::V1::RecipesController < ApplicationController

  def index

    # recipes.each do |r|
    #   Recipe.find_or_create_by(
    #     title: r["title"],
    #     recipe_id: r["recipe_id"],
    #     image_url: r["image_url"],
    #     rating: r["social_rank"],
    #     source_url: r["source_url"],
    #     publisher: r["publisher"])
    # end


    recipes = Recipe.all
    # recipes.each do |r|

    # end

    render json: recipes
  end

end
