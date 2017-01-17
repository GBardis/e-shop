class Product < ApplicationRecord
    belongs_to :category, inverse_of: :products
    has_many :images, dependent: :destroy, inverse_of: :product
    accepts_nested_attributes_for :images
    has_many :comments
    has_many :order_items

    default_scope { where(active: true) }

    paginates_per 5
    max_paginates_per 6

    ratyrate_rateable 'product'

    def create_associated_image(image)
        images.create(image: image)
  end
end
