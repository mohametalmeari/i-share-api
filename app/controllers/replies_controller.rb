class RepliesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Access denied' }
  end

  def index
    comment = Comment.find_by(photo_id: params[:photo_id], id: params[:comment_id])
    replies = Reply.where(comment:)&.order(created_at: :desc)
    render json: replies, status: :ok
  end

  def create
    reply = Reply.new(content: params[:content], comment_id: params[:comment_id], user: current_user)
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
    comment = Comment.find_by(photo_id: params[:photo_id], id: params[:comment_id])
    reply = Reply.find_by(id: params[:id], comment:)
    if reply&.destroy
      render json: { messsage: 'deleted' }, status: :ok
    elsif !reply
      render json: { error: 'not found' }, status: :not_found
    else
      render json: { error: 'failed to delete' }, status: :unprocessable_entity
    end
  end
end
