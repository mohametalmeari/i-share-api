class PhotosController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Access denied' }
  end

  def index
    photos = Photo.where(archive: false).order(created_at: :desc)
    render json: photos, status: :ok
  end

  def create
    photo = Photo.new(photo_params)
    photo.user = current_user
    if photo.save
      render json: { messsage: 'saved' }, status: :created
    else
      render json: { error: 'failed to save' }, status: :unprocessable_entity
    end
  end

  def show
    photo = Photo.find_by_id(params[:id])
    if photo
      render json: photo, status: :ok
    else
      render json: { error: 'not found' }, status: :not_found
    end
  end

  def update
    photo = Photo.find_by_id(params[:id])
    if photo
      photo.archive = !photo.archive
      if photo.save
        render json: { archive: photo.archive }, status: :ok
      else
        render json: { error: 'failed to change' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'not found' }, status: :not_found
    end
  end

  def destroy
    photo = Photo.find_by_id(params[:id])
    if photo&.destroy
      render json: { messsage: 'deleted' }, status: :ok
    elsif !photo
      render json: { error: 'not found' }, status: :not_found
    else
      render json: { error: 'failed to delete' }, status: :unprocessable_entity
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:image_url, :caption)
  end
end
