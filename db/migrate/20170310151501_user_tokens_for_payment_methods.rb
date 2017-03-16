class UserTokensForPaymentMethods < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_methods_tokens do |t|
      t.string :token
      t.references :user
    end
  end
end
