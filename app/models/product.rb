class Product < ApplicationRecord
    belongs_to :category, inverse_of: :products
    has_many :images, dependent: :destroy, inverse_of: :product

    def create_associated_image(image)
        images.create(image: image)
  end
end
