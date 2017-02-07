class CommentsController < ApplicationController
  before_action :find_product

  def create
    @comment = @products.comments.create(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    respond_to do |format|
      format.js { render 'comments/create' }
    end
    if @comment.save
      flash[:success] = 'Your comment was successfully added!'
    # respond_to do |format|
    # format.html { redirect_to product_path(@products) }
    #  format.js
    # end
    # redirect_to product_path(@products)
    else
      render 'new'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.js { render 'comments/destroy' }
    end
  end

  private

  def find_product
    @products = Product.find(params[:product_id])
  end

  def comment_params
    params.require(:comment).permit(:title, :body, :author, :user_id, :product_id)
  end
end
