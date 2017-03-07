class CommentsController < ApplicationController
  before_action :find_product

  def create
    @comment = @product.comments.create(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    respond_to do |format|
      format.js { render 'comments/create' }
    end
    if @comment.save

      # flash.now[:notice] = 'Your comment was successfully added!'
      respond_to do |format|
        format.js { render 'comments/create.js.erb' }
      end

    # redirect_to product_path(@products)
    else
      render 'new'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
<<<<<<< HEAD
    # flash.now[:alert] = 'Your comment was successfully added!'
    respond_to do |format|
      format.js { render 'comments/destroy.js.erb' }
=======
    respond_to do |format|
      format.js { render 'comments/destroy' }
>>>>>>> addfavorites
    end
  end

  private

  def find_product
    @product = Product.find(params[:product_id])
  end

  def comment_params
    params.require(:comment).permit(:title, :body, :author, :user_id, :product_id)
  end
end
