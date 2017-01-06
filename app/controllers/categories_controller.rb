class CategoriesController < ApplicationController
    def index
        # #@category = nil
        @categories = Category.find(:all, conditions: { parent_id: nil })
    end

    def show
        # Find the category belonging to the given id
        @category = Category.find(params[:id])
        # Grab all sub-categories
        @categories = @category.subcategories
        # We want to reuse the index renderer:
        render action: :application
    end

    def new
        @category = Category.new
        @category.parent = Category.find(params[:id]) unless params[:id].nil?
    end

    def create
        @category = Category.create(category_params)
    end

    private

    def category_params
        params.require(:category).permit(:name, :product_id, :parent_id)
    end
end
