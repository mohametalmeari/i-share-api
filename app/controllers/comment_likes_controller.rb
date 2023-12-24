class CommentLikesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Access denied' }
  end

  def index
    photo = Photo.find_by(id: params[:photo_id], archive: false)
    comment = Comment.find_by(photo:, id: params[:comment_id])
    likes = CommentLike.where(comment:)&.order(created_at: :desc)
    render json: likes, status: :ok
  end

  def create
    photo = Photo.find_by(id: params[:photo_id], archive: false)
    comment = Comment.find_by(photo:, id: params[:comment_id])
    like = CommentLike.new(comment:, user: current_user)
    if like.save
      render json: { liked: true, likes: comment.count_likes }, status: :created
    else
      render json: { error: 'failed to like' }, status: :unprocessable_entity
    end
  end

  def destroy
    photo = Photo.find_by(id: params[:photo_id], archive: false)
    comment = Comment.find_by(photo:, id: params[:comment_id])
    like = CommentLike.find_by(comment:, user: current_user)
    if like&.destroy
      render json: { liked: false, likes: comment.count_likes }, status: :ok
    else
      render json: { error: 'failed to unlike' }, status: :unprocessable_entity
    end
  end
end
