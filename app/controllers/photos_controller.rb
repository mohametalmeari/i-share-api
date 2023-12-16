class PhotosController < ApplicationController
  # before_action :authenticate_user!

  def index
    photos = Photo.all.order(created_at: :desc)
    render json: photos
  end

  def create
    image_url = params[:image_url]
    caption = params[:caption]
    user = User.find(params[:user_id])
    photo = Photo.new(image_url:, caption:, user:)

    # photo.user = current_user
    if photo.save
      render json: { messsage: 'saved' }, status: :created
    else
      render json: { error: 'failed to save' }, status: :unprocessable_entity
    end
  end

  def show
    photo = Photo.find_by_id(params[:id])
    if photo
      render json: photo
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
    params.require(:photo).permit(:image_url, :caption, :archive)
  end
end
