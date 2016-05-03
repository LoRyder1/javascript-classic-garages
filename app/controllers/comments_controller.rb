class CommentsController < ApplicationController  
  def create
    @car = Garage.find(params[:garage_id])
    @comment = @car.comments.create(comment_params)
    redirect_to garage_path(@car)
  end

  def destroy
    @car = Garage.find(params[:garage_id])
    @comment = @car.comments.find(params[:id])
    @comment.destroy
    redirect_to garage_path(@car)
  end

  private
  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
