require 'elasticsearch/model'
class Product < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    belongs_to :category, inverse_of: :products
    has_many :images, dependent: :destroy, inverse_of: :product
    accepts_nested_attributes_for :images
    has_many :comments
    has_many :order_items

    default_scope { where(active: true) }

    paginates_per 5
    max_paginates_per 6

    ratyrate_rateable 'product'
    def self.search(query)
        __elasticsearch__.search(
            query: {
                multi_match: {
                    query: query,
                    fields: ['title^10', 'description']
                }
            },
            highlight: {
                pre_tags: ['<em>'],
                post_tags: ['</em>'],
                fields: {
                    title: {},
                    description: {}
                }
            }
        )
 end
    settings index: { number_of_shards: 1 } do
        mappings dynamic: 'false' do
            indexes :title, analyzer: 'english', index_options: 'offsets'
            indexes :description, analyzer: 'english'
        end
    end

    def create_associated_image(image)
        images.create(image: image)
  end
end
# Delete the previous articles index in Elasticsearch
begin
    Product.__elasticsearch__.client.indices.delete index: Product.index_name
rescue
    nil
end

# Create the new index with the new mapping
Product.__elasticsearch__.client.indices.create \
    index: Product.index_name,
    body: { settings: Product.settings.to_hash, mappings: Product.mappings.to_hash }
Product.import force: true # for auto sync model with elastic search
