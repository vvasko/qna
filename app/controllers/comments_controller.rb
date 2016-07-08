class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  before_action :load_comment, only: :destroy
  before_action :check_author, only: :destroy

  respond_to :js

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  def destroy
    respond_with(@comment.destroy)
  end

  private

  def set_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @commentable = $1.classify.constantize.find(value)
      end
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def check_author
    unless current_user.is_author?(@comment)
      flash[:notice] = 'Permission denied.'
      redirect_to :back
    end
  end
end
