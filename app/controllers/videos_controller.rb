class VideosController < ApplicationController
  
  before_action :require_user
  
  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews
  end
  
  def search
    @search_results = Video.search_by_title(params[:video_title])
  end
  
end