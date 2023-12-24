class PhotoLikesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Access denied' }
  end

  def index
    photo = Photo.find_by(id: params[:photo_id], archive: false)
    likes = PhotoLike.where(photo:)&.order(created_at: :desc)
    render json: likes, status: :ok
  end

  def create
    photo = Photo.find_by(id: params[:photo_id], archive: false)
    like = PhotoLike.new(photo:, user: current_user)
    if like.save
      render json: { liked: true, likes: photo.count_likes }, status: :created
    else
      render json: { error: 'failed to like' }, status: :unprocessable_entity
    end
  end

  def destroy
    photo = Photo.find_by(id: params[:photo_id], archive: false)
    like = PhotoLike.find_by(photo:, user: current_user)
    if like&.destroy
      render json: { liked: false, likes: photo.count_likes }, status: :ok
    else
      render json: { error: 'failed to unlike' }, status: :unprocessable_entity
    end
  end
end
