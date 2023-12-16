class ReplyLikesController < ApplicationController
  def index
    comment = Comment.find_by(photo_id: params[:photo_id], id: params[:comment_id])
    reply = Reply.find_by(comment:, id: params[:reply_id])
    likes = ReplyLike.where(reply:)&.order(created_at: :desc)
    render json: likes, status: :ok
  end

  def create
    like = ReplyLike.new(reply_id: params[:reply_id], user: current_user)
    if like.save
      render json: { messsage: 'liked' }, status: :created
    else
      render json: { error: 'failed to like' }, status: :unprocessable_entity
    end
  end

  def destroy
    comment = Comment.find_by(photo_id: params[:photo_id], id: params[:comment_id])
    reply = Reply.find_by(comment:, id: params[:reply_id])
    like = ReplyLike.find_by(reply:, user: current_user)
    if like&.destroy
      render json: { messsage: 'unliked' }, status: :ok
    else
      render json: { error: 'failed to unlike' }, status: :unprocessable_entity
    end
  end
end
