class OrdersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: -> { render_404  }
  before_action :page_title
  def show
    @orders = Order.where(user_id: current_user.id, status:[0,2,3]).order('created_at DESC')
  end

  def order_details
    begin
      @order = Order.find(params[:id])
      @order_details = @order.order_items.order('created_at DESC')
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Η παραγγελία που ψάχνεται δεν υπάρχει"
      if current_user
        redirect_to orders_path(current_user)
      else
        flash[:notice] = "Η παραγγελία που ψάχνεται δεν υπάρχει"
        redirect_to root_path
      end
    end
  end


  private
  def page_title
    @meta_title = meta_title 'Ιστορικό Παραγγελιών'
  end
end
