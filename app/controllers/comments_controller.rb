class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    comments = Comment.where(photo_id: params[:photo_id])&.order(created_at: :desc)
    render json: comments, status: :ok
  end

  def create
    comment = Comment.new(content: params[:content], photo_id: params[:photo_id], user: current_user)
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
    comment = Comment.find_by(id: params[:id], photo_id: params[:photo_id])
    if comment&.destroy
      render json: { messsage: 'deleted' }, status: :ok
    elsif !comment
      render json: { error: 'not found' }, status: :not_found
    else
      render json: { error: 'failed to delete' }, status: :unprocessable_entity
    end
  end
end