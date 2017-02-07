class AddIndexToFavorites < ActiveRecord::Migration[5.0]
  def change
    add_reference :favorites, :product, index: true, foreign_key: true
  end
end
