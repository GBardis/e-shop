class Image < ApplicationRecord
  belongs_to :product, inverse_of: :images

  has_attached_file	:image,
                    path: ':rails_root/public/images/:id/:filename', # CW branch
                    url: '/images/:id/:filename', # CW branch
                    default_url: 'missing/no-image.png'
  # styles: { large: '600x600>', medium: '250x250>', thumb: '420x250>' }
  #:default_url => ActionController::Base.helpers.asset_path("/images/missing.png")
  #:default_url => lambda { |photo| photo.instance.set_default_url}

  validates_attachment_content_type :image, content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
end
