class AddUserToOrderItems < ActiveRecord::Migration[5.0]
  def change
    add_reference :order_items, :product, foreign_key: true
  end
end
