class AboutController < ApplicationController
  def index
    render json: { about: 'i-Share API' }
  end
end
