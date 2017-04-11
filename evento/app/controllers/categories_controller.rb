class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :update, :destroy, :events, :subcategories]
  skip_before_action :authenticate_request

  # GET /categories
  def index
    @categories = Category.all

    render json: @categories
  end

  # GET /categories/1
  def show
    render json: @category
  end

  # GET /categories/1/subcategories
  def subcategories
    render json: @category.get_subcategories
  end

  # GET /categories/1/events
  def events
    render json: @category.get_events
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end
end
