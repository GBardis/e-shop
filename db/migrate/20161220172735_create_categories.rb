class CreateCategories < ActiveRecord::Migration[5.0]
    def self.up
        create_table :categories do |t|
            t.string :name
            t.references :product
            t.references :parent
        end
     end

    def self.down
        drop_table :categories
    end
 end
