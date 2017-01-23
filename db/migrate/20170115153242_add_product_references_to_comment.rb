class AddProductReferencesToComment < ActiveRecord::Migration[5.0]
    def change
        add_reference :comments, :product, index: true
    end
end
