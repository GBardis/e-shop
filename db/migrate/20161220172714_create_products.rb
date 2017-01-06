class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.float :price
      t.integer :stock
      t.references :category

      t.timestamps
    end
  end
end
