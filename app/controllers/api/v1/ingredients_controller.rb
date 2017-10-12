class Api::V1::IngredientsController < ApplicationController

  def create
    ingredientInput = ingredient_params["ingredient"].downcase
    ingredient = Ingredient.find_by(name: ingredientInput)
    if ingredient != nil
      UserIngredient.find_or_create_by(user_id: current_user[:id], ingredient_id: ingredient[:id])
    else
      ingredient = Ingredient.create(name: ingredientInput)
      UserIngredient.create(user_id: current_user[:id], ingredient_id: ingredient[:id])

      fetch_recipes(ingredientInput)

      Recipe.all.each do |recipe|
        if recipe["ingredientList"].include?(ingredientInput)
          RecipeIngredient.create(recipe_id: recipe[:id], ingredient_id: ingredient[:id])
        end
      end
    end

    send_recipes

    # user_ingredients = current_user.ingredients
    #
    # recipes_list = Recipe.all.select do |recipe|
    #   recipe_ingredients = recipe["ingredientList"].split("---")
    #   matched_ingredients = recipe_ingredients.select do |ingredient|
    #       user_ingredients.find{|i| ingredient.downcase.include?(i["name"].downcase)} #exit loop if false
    #   end
    #   recipe_ingredients.length == matched_ingredients.length
    # end
    #
    # render json: {recipes: recipes_list, ingredients: user_ingredients}
  end

  def destroy
    ingredientInput = ingredient_params["ingredient"]
    ingredient = Ingredient.find_by(name: ingredientInput)
    UserIngredient.find_by(user_id: current_user[:id], ingredient_id: ingredient[:id]).destroy

    send_recipes

    # user_ingredients = current_user.ingredients
    #
    # recipes_list = Recipe.all.select do |recipe|
    #   recipe_ingredients = recipe["ingredientList"].split("---")
    #   matched_ingredients = recipe_ingredients.select do |ingredient|
    #       user_ingredients.find{|i| ingredient.downcase.include?(i["name"].downcase)} #exit loop if false
    #   end
    #   recipe_ingredients.length == matched_ingredients.length
    # end
    #
    # render json: {recipes: recipes_list, ingredients: user_ingredients}
  end

  private

  def ingredient_params
    params.permit(:ingredient)
  end

  def fetch_recipes(ingredient)
    recipes = JSON.parse(RestClient.get("http://food2fork.com/api/search?key=43829fa2bde4a7bc381a9dd6b44f794b&q=#{ingredient}"))["recipes"]

    new_recipes = []
    recipes.each do |r|
      new_recipes << Recipe.find_or_create_by(
        title: r["title"],
        recipe_id: r["recipe_id"],
        image_url: r["image_url"],
        rating: r["social_rank"],
        source_url: r["source_url"],
        publisher: r["publisher"])
    end

    new_recipes.each do |recipe|
      recipe.update(ingredientList: JSON.parse(RestClient.get("http://food2fork.com/api/get?key=43829fa2bde4a7bc381a9dd6b44f794b&rId=#{recipe["recipe_id"]}"))["recipe"]["ingredients"].join("---"))
      Ingredient.all.each do |ingredient|
        if recipe[:ingredientList].downcase.include?(ingredient[:name].downcase)
          RecipeIngredient.create(recipe_id: recipe[:id], ingredient_id: ingredient[:id])
        end
      end
    end

  end

end
