class SearchController < ApplicationController
    def search
        @products = if params[:q].nil?
                        []
                    else
                        Product.search params[:q]
                    end
  end
end
