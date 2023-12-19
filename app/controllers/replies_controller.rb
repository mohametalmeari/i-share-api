class RepliesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Access denied' }
  end

  def index
    photo = Photo.find_by(id: params[:photo_id], archive: false)
    comment = Comment.find_by(photo:, id: params[:comment_id])
    replies = Reply.where(comment:)&.order(created_at: :desc)
    render json: replies, status: :ok
  end

  def create
    photo = Photo.find_by(id: params[:photo_id], archive: false)
    comment = Comment.find_by(photo:, id: params[:comment_id])
    reply = Reply.new(reply_params)
    reply.comment = comment
    reply.user = current_user
    if reply.save
      render json: { messsage: 'saved' }, status: :created
    else
      render json: { error: 'failed to save' }, status: :unprocessable_entity
    end
  end

  def show
    comment = Comment.find_by(photo_id: params[:photo_id], id: params[:comment_id])
    reply = Reply.find_by(id: params[:id], comment:)
    if reply
      render json: reply, status: :ok
    else
      render json: { error: 'not found' }, status: :not_found
    end
  end

  def destroy
    photo = Photo.find_by(id: params[:photo_id], archive: false)
    comment = Comment.find_by(photo:, id: params[:comment_id])
    reply = Reply.find_by(id: params[:id], comment:)
    if reply&.destroy
      render json: { messsage: 'deleted' }, status: :ok
    elsif !reply
      render json: { error: 'not found' }, status: :not_found
    else
      render json: { error: 'failed to delete' }, status: :unprocessable_entity
    end
  end

  private

  def reply_params
    params.permit(:content)
  end
end
