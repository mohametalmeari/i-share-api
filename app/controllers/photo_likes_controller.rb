class PhotoLikesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Access denied' }
  end

  def index
    photo = Photo.find_by(id: params[:photo_id], archive: false)
    return render json: { error: 'Access denied' } unless photo
    likes = PhotoLike.where(photo:)&.order(created_at: :desc)
    render json: likes, status: :ok
  end

  def create
    like = PhotoLike.new(photo_id: params[:photo_id], user: current_user)
    if like.save
      render json: { messsage: 'liked' }, status: :created
    else
      render json: { error: 'failed to like' }, status: :unprocessable_entity
    end
  end

  def destroy
    like = PhotoLike.find_by(photo_id: params[:photo_id], user: current_user)
    if like&.destroy
      render json: { messsage: 'unliked' }, status: :ok
    else
      render json: { error: 'failed to unlike' }, status: :unprocessable_entity
    end
  end
end
