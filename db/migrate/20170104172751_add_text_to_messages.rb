class AddTextToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :msg, :text
  end
end
