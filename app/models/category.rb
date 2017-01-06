class Category < ApplicationRecord
    def nested_products
        Product.where(category_id: subcategories.select(:id))
    end

    def nested_categories
        subcategories
    end

    has_many :products, inverse_of: :category
    has_many :subcategories, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
    belongs_to :parent_category, class_name: 'Category'
    accepts_nested_attributes_for :products
end
