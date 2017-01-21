class CommentsController < ApplicationController
    before_action :find_product

    def create
        @comment = @products.comments.create(comment_params)
        @comment.user_id = current_user.id
        @comment.save

        if @comment.save
            flash[:success] = 'Your comment was successfully added!'
            redirect_to product_path(@products)
        else
            render 'new'
        end
    end

    def destroy
        @comment = Comment.find(params[:id])
        @comment.destroy
        # redirect_to_product_path(@products)
    end

    private

    def find_product
        @products = Product.find(params[:product_id])
     end

    def comment_params
        params.require(:comment).permit(:title, :body, :author, :user_id, :product_id)
    end
end
