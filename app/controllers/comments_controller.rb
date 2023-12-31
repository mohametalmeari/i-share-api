class CommentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Access denied' }
  end

  def index
    photo = Photo.find_by(id: params[:photo_id], archive: false)
    comments = Comment.where(photo:)&.order(created_at: :desc)
    response = comments.map do |comment|
      {
        id: comment.id,
        content: comment.content,
        likes: comment.count_likes,
        liked: comment.liked?(current_user),
        replies: comment.count_replies,
        user: {
          name: comment.user.name,
          username: comment.user.username,
          control: comment.user == current_user || current_user.email == 'admin@email.com'
        }
      }
    end

    render json: response, status: :ok
  end

  def create
    photo = Photo.find_by(id: params[:photo_id], archive: false)
    comment = Comment.new(comment_params)
    comment.photo = photo
    comment.user = current_user
    if comment.save
      render json: { messsage: 'saved' }, status: :created
    else
      render json: { error: 'failed to save' }, status: :unprocessable_entity
    end
  end

  def show
    comment = Comment.find_by(id: params[:id], photo_id: params[:photo_id])
    if comment
      render json: comment, status: :ok
    else
      render json: { error: 'not found' }, status: :not_found
    end
  end

  def destroy
    photo = Photo.find_by(id: params[:photo_id], archive: false)
    comment = Comment.find_by(id: params[:id], photo:)
    if comment&.destroy
      render json: { message: 'deleted' }, status: :ok
    elsif !comment
      render json: { error: 'not found' }, status: :not_found
    else
      render json: { error: 'failed to delete' }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.permit(:content)
  end
end
