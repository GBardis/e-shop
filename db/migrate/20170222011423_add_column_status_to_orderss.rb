class AddColumnStatusToOrderss < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :status, :integer, default: 1
  end
end
