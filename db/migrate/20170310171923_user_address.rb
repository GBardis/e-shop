class UserAddress < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :address_id
      t.references :user
    end
  end
end
