class CommentLikesController < ApplicationController
  before_action :authenticate_user!

  def index
    comment = Comment.find_by(photo_id: params[:photo_id], id: params[:comment_id])
    likes = CommentLike.where(comment:)&.order(created_at: :desc)
    render json: likes, status: :ok
  end

  def create
    like = CommentLike.new(comment_id: params[:comment_id], user: current_user)
    if like.save
      render json: { messsage: 'liked' }, status: :created
    else
      render json: { error: 'failed to like' }, status: :unprocessable_entity
    end
  end

  def destroy
    comment = Comment.find_by(photo_id: params[:photo_id], id: params[:comment_id])
    like = CommentLike.find_by(comment:, user: current_user)
    if like&.destroy
      render json: { messsage: 'unliked' }, status: :ok
    else
      render json: { error: 'failed to unlike' }, status: :unprocessable_entity
    end
  end
end
