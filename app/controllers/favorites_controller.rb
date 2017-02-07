class FavoritesController < ApplicationController
  before_action :set_favorite
  before_action :set_product
  def show
    @favorites = Favorites.where(favorited: @products, user: current_user, product: product.id)
  end

  def set_favorite
    @favorites = Favorite.find(params[:id])
    @favorite = Favorite.where(favorite: @product, product_id: product.id, user_id: user.id)
  end

  def set_product
    @products = Product.find(params[:product_id] || params[:id])
  end
end
