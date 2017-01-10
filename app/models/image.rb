class Image < ApplicationRecord
    belongs_to :product

    has_attached_file	:image,
                      path: ':rails_root/public/images/:id/:filename', # CW branch
                      url: '/images/:id/:filename', # CW branch
                      styles: { large: '600x600>', medium: '250x250>', thumb: '420x250#' }
    #:default_url => ActionController::Base.helpers.asset_path("/images/missing.png")
    #:default_url => lambda { |photo| photo.instance.set_default_url}

    do_not_validate_attachment_file_type :image # CW branch
end
