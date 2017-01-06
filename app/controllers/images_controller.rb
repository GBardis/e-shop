class ImagesController < ApplicationController
    def index
        @Product = Product.find(params[:product_id])

        @images = @product.images

        respond_to do |format|
            format.html # index.html.erb
            format.json { render json: @images }
        end
   end

    def show
        @image = Image.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.json { render json: @image }
        end
     end
end
