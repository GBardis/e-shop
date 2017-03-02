class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :product
    # acts_as_tree order: 'created_at DESC'
end
