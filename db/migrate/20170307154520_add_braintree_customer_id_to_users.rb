class AddBraintreeCustomerIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :braintree_customer_id, :string
  end
end
