require_relative 'non_ingredients'

class Api::V1::RecipesController < ApplicationController

  def index
    send_recipes
  end

end
