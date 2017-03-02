class ImagesController < ApplicationController
  def index
    @product = Product.find(params[:product_id])
    @images = Image.find(params[:id])

    @images = @product.images

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @images }
    end
  end

  def show
    @image = Image.find(params[:id])
    @products = @image.products

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
