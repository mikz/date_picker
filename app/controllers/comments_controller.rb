class CommentsController < ApplicationController
  def destroy
    @comment = Comment.find_by_id params[:id]
    if @comment.user == current_user || current_user.admin?
      @comment.destroy
      flash[:notice] = t(:comment_deleted)
    else
      flash[:notice] = t(:dont_have_permission)
    end
    redirect_to :back
  end
  
  def create
    @comment = Comment.new params[:comment]
    @comment.user = current_user
    if @comment.valid? && @comment.save
      flash[:notice] = t(:comment_saved)
      redirect_to :back
    else
      render
    end
  end
end