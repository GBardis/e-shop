class AddTitleToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :title, :text
  end
end
