class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :current_order
  helper_method :current_order

  def current_order
    if !session[:order_id].nil? && !current_user
      Order.find(session[:order_id])
    elsif session[:order_id].nil?
      Order.new
    elsif current_user && current_user.orders.exists?
      current_user.orders.last
    elsif current_user && !current_user.orders.exists?
      Order.new
    end
  end
end
