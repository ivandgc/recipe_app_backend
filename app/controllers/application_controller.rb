class ApplicationController < ActionController::API

  def send_recipes()
    user_ingredients = current_user.ingredients #ing.reci

    recipes_list = Recipe.all
    # if recipes_list[0] != nil

    unmatched_recipes = []
    unmatched_ingredients = []

    recipes_list = recipes_list.select do |recipe|

      recipe_ingredients = recipe[:ingredientList].split("---")

      unmatched_recipes << {}
      unmatched_recipes[(unmatched_recipes.length - 1)][:recipe] = recipe
      unmatched_recipes[(unmatched_recipes.length - 1)][:missing_ingredients] = []

      matched_ingredients = recipe_ingredients.select do |ingredient|
        match = user_ingredients.find{|i| ingredient.downcase.include?(i["name"].downcase)} #exit loop if false
        if match == nil
          unmatched_recipes[(unmatched_recipes.length - 1)][:missing_ingredients] << ingredient.downcase
        end
        match
      end

      if recipe_ingredients.length != matched_ingredients.length && recipe_ingredients.length <= (matched_ingredients.length + 1)
        unmatched_ingredients << unmatched_recipes[(unmatched_recipes.length - 1)][:missing_ingredients]
      else
        unmatched_recipes.pop
      end

      recipe_ingredients.length == matched_ingredients.length
    end

    common_missing_ingredients = count_ingredients(unmatched_ingredients).sort { |l, r| r[1]<=>l[1] }.first(5) #.to_h or .collect{|i| i[0]}
    # end

    render json: {recipes: recipes_list,
                  ingredients: user_ingredients,
                  user: current_user,
                  missing_ingredients: common_missing_ingredients,
                  partial_matches: unmatched_recipes}
  end

  def issue_token(payload)
    JWT.encode(payload, "cookit")
  end


  def decoded_token(token)
    begin
      JWT.decode(token, "cookit")
    rescue JWT::DecodeError
      []
    end
  end

  def token

    if bearer_token = request.headers["Authorization"]
      jwt_token = bearer_token.split(" ")[1]
    else
      # no return
    end

  end

  def current_user
    decoded_hash = decoded_token(token)
    if !decoded_hash.empty?
      user_id = decoded_hash[0]["user_id"]
      user = User.find(user_id)
    else
    end
  end

  def logged_in?
    !!current_user
  end


  def authorized
    redirect_to '/api/v1/login' unless logged_in?
  end

  private

  def count_ingredients(ingredients)
    tokens = ingredients.join(" ").split(/[\s,\/()]/)
    tokens.inject(Hash.new(0)) {|counts, token| (counts[token] += 1) if !NON_INGREDIENTS.include?(token); counts}
  end

end
