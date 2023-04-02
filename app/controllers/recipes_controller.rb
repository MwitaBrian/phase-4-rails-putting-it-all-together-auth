class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    if logged_in?
      render json: Recipe.all.as_json(include: { user: { only: [:id, :username, :image_url, :bio] } }), status: :ok
    else
      render json: { error: "You must be logged in to access this resource" }, status: :unauthorized
    end
  end

  def create
    recipe = current_user.recipes.build(recipe_params)
    if recipe.save
      render json: recipe.as_json(include: { user: { only: [:id, :username, :image_url, :bio] } }), status: :created
    else
      render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :instructions, :minutes_to_complete)
  end
end
