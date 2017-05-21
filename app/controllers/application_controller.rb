class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # rescue_from ActionController::RoutingError, with: -> { render_404  }
  # rescue_from ActiveRecord::RecordNotFound, with: -> { render_404  }

  before_action :order
  before_action :current_order
  before_action :category
  helper_method :current_order

  BRAND_NAME = 'ΑΠΟΨΗ'.freeze

  def meta_title(title)
    [title, BRAND_NAME].reject(&:empty?).join(' | ')
  end

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
  # def render_404(exception = nil)
  #   flash[:notice] = "Η παραγγελία που ψάχνεται δεν υπάρχει"
  #   redirect_to root_path
  #    if exception
  #      logger.info "Rendering 404: #{exception.message}"
  #    end
  #    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  # end
  def category
    @categories = Category.all.where(parent_id: nil)
  end

  def order
    if current_user
      @order_inprogress = Order.where(user_id: current_user.id , status: 1)
    end
  end
end
