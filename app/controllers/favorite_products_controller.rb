class FavoriteProductsController < ApplicationController
  before_action :set_product
  def create
    Favorite.create(favorited: @products, user: current_user, product_id: @products.id)
    respond_to do |format|
      # format.js { render 'layouts/flash_messages.js.erb' } # { flash.now[:notice] = 'Προστέθηκε Στα Αγαπημένα' }
      format.js { render 'favorites/create.js.erb' }
    end
    # redirect_to @products, notice: 'Προστέθηκε Στα Αγαπημένα '
  end

  def show
    @favorites = Favorite.where(favorited: @products, favorited_id: @favorites.favorited_id, user_id: current_user.id, product_id: @products.id)
  end

  def destroy
    Favorite.where(favorited_id: @products.id, user_id: current_user.id).first.destroy
    respond_to do |format|
      # format.html { alert:'Αφαιρέθηκε απο τα Αγαπημένα' }
      # format.js { render 'layouts/flash_messages.js.erb' }
      format.js { render 'favorites/destroy.js.erb' }
    end

    # redirect_to @products, notice: 'Αφαιρέθηκε απο τα Αγαπημένα'
  end

  private

  def set_favorite
    @favorites = Favorite.find(params[:id])
  end

  def set_product
    @products = Product.find(params[:product_id] || params[:id])
  end
end
