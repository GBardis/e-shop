#cart_dropdown helper take the logic from view
module CartsHelper

  def user_order_exists
    if current_user && current_user.orders.exists?
      return true
    else
      return false
    end
  end

  def current_order_exist
    if current_order.order_items.size == 0 && !current_user
      return true
    else
      return false
    end
  end

  def order_inprogress
    if current_user
      if current_user.orders.in_progress.last.blank?
        return true
      else
        return false
      end
    end
  end

  def subtotal
    if current_user
      number_to_currency current_user.orders.last.subtotal
    else
      number_to_currency current_order.subtotal
    end
  end

  def total
    if current_user && user_order_exists == true
      number_to_currency current_user.orders.in_progress.last.subtotal
    else
      number_to_currency current_order.subtotal
    end
  end

  def product_price(order_item)
    number_to_currency order_item.unit_price
  end
  def order_size
    if current_user
      current_user.orders.last.order_items.size
    else
      current_order.order_items.size
    end
  end

end
