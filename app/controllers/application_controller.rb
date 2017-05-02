class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :order
  before_action :current_order
  helper_method :current_order

  def current_order
    if !session[:order_id].nil? && !current_user
      Order.find(session[:order_id])
    elsif session[:order_id].nil? && !current_user
      Order.new
    elsif current_user && !@order_inprogress.blank?
      current_user.orders.in_progress.last
    elsif current_user && @order_inprogress.blank?
      Order.new
    end
  end

  private

  def order
    if current_user
      @order_inprogress = Order.where(user_id: current_user.id , status: 1)
      #byebug
    end
  end
end
