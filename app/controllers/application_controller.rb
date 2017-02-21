class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :current_order
  helper_method :current_order

  def current_order
    # if session[:order_id].nil?
    #  Order.new

    # elsif !session[:order_id].nil? && current_user && current_user.orders
    # !session[:order_id].nil? && current_user && current_user.orders
    # current_user.orders.last
    # end
    # if !session[:order_id].nil?
    #  Order.find(session[:order_id])
    # elsif current_user && current_user.orders.exists?
    #  current_user.orders.last
    # elsif current_user && current_user.orders.nil?
    #  Order.new
    # end
    # end

    if !session[:order_id].nil?
      Order.find(session[:order_id])
    else

      Order.new
    end
  end
end
