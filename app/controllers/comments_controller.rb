class CommentsController < ApplicationController
    before_action :find_product

    def create
        if parms[:comment][:parent_id].to_i > 0
            parent = Comment.find_by_id(params[:comment].delete(parent_id))
            @comment = parent.children.build(commnet_params)
        else
            @comment = @products.comments.create(comment_params)
            @comment.user_id = current_user.id
            @comment.save
        end
        if @comment.save
            flash[:success] = 'Your comment was successfully added!'
            redirect_to product_path(@products)
        else
            render 'new'
        end
    end

    def destroy
        @comment.destroy
        redirect_to_product_path(@products)
    end

    private

    def find_product
        @products = Product.find(params[:product_id])
     end

    def comment_params
        params.require(:comment).permit(:title, :body, :author, :user_id, :product_id)
    end
end
