class PhotosController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Access denied' }
  end

  def index
    photos = Photo.where(archive: false).order(created_at: :desc).includes(:user)
    response = photos.map do |photo|
      {
        id: photo.id,
        image_url: photo.image_url,
        caption: photo.caption,
        likes: photo.count_likes,
        liked: photo.liked?(current_user),
        comments: photo.count_comments,
        user: {
          name: photo.user.name,
          username: photo.user.username,
          control: photo.user == current_user || current_user.email == 'admin@email.com',
          profile_image: photo.user.image_url
        }
      }
    end

    render json: response, status: :ok
  end

  def my_photos
    photos = Photo.where(user: current_user).order(created_at: :desc).includes(:user)
    response = photos.map do |photo|
      {
        id: photo.id,
        image_url: photo.image_url,
        caption: photo.caption,
        likes: photo.count_likes,
        liked: photo.liked?(current_user),
        archive: photo.archive,
        comments: photo.count_comments,
        user: {
          name: photo.user.name,
          username: photo.user.username,
          control: photo.user == current_user,
          profile_image: photo.user.image_url
        }
      }
    end

    render json: response, status: :ok
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

  def show # rubocop:disable Metrics/MethodLength
    photo = Photo.find_by_id(params[:id])
    if photo
      response = {
        id: photo.id,
        image_url: photo.image_url,
        caption: photo.caption,
        likes: photo.count_likes,
        liked: photo.liked?(current_user),
        archive: photo.archive,
        comments: photo.count_comments,
        user: {
          name: photo.user.name,
          username: photo.user.username,
          control: photo.user == current_user || current_user.email == 'admin@email.com',
          profile_image: photo.user.image_url
        }
      }
      render json: response, status: :ok
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
      render json: { message: 'deleted' }, status: :ok
    elsif !photo
      render json: { error: 'not found' }, status: :not_found
    else
      render json: { error: 'failed to delete' }, status: :unprocessable_entity
    end
  end

  private

  def photo_params
    params.permit(:image_url, :caption)
  end
end
