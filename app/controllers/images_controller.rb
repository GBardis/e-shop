class ImagesController < ApplicationController
    def index
        @product = Product.find(params[:product_id])
        @image = Image.find(params[:id])
        @images = @product.images
   end

    def show
        @image = Image.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.json { render json: @image }
        end
     end

    private

    def image_params
        params.require(:image).permit(:product_id, :image)
    end
end
