class Api::CommentsController < ApplicationController



  def create
    comment = Comment.new(comment_params)

    respond_to do |format|
      if comment.save
        format.json {render json: comment.as_json.merge(user: comment.user) }
      else
        format.json {render json: comments.errors}
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:news_id, :text, :user_id)
  end
end
