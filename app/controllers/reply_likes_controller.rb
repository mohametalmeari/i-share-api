class ReplyLikesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Access denied' }
  end

  def index
    photo = Photo.find_by(id: params[:photo_id], archive: false)
    comment = Comment.find_by(photo:, id: params[:comment_id])
    reply = Reply.find_by(comment:, id: params[:reply_id])
    likes = ReplyLike.where(reply:)&.order(created_at: :desc)
    render json: likes, status: :ok
  end

  def create
    photo = Photo.find_by(id: params[:photo_id], archive: false)
    comment = Comment.find_by(photo:, id: params[:comment_id])
    reply = Reply.find_by(comment:, id: params[:reply_id])
    like = ReplyLike.new(reply:, user: current_user)
    if like.save
      render json: { liked: true, likes: reply.count_likes }, status: :created
    else
      render json: { error: 'failed to like' }, status: :unprocessable_entity
    end
  end

  def destroy
    photo = Photo.find_by(id: params[:photo_id], archive: false)
    comment = Comment.find_by(photo:, id: params[:comment_id])
    reply = Reply.find_by(comment:, id: params[:reply_id])
    like = ReplyLike.find_by(reply:, user: current_user)
    if like&.destroy
      render json: { liked: false, likes: reply.count_likes }, status: :ok
    else
      render json: { error: 'failed to unlike' }, status: :unprocessable_entity
    end
  end
end
