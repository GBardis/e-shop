class FavoritesController < ApplicationController
  before_action :validate_authorization_for_user
  before_action :page_title
  def show
    @favorite = current_user.favorite_products
    @order_item = current_order.order_items.new

  end

  private

  def page_title
    @meta_title = meta_title 'Αγαπημένα'
  end
  def validate_authorization_for_user
    unless current_user
      redirect_to new_user_session_path
      flash[:notice] = 'Πρέπει να συνδεθείτε για να μπορείτε να προσθέσετε στα αγαπημένα'
    end
  end
end
