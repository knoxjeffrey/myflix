class VideosController < ApplicationController
  
  def show
    @video = Video.find(params[:id])
  end
  
  def search
    @search_results = Video.search_by_title(params[:video_title])
  end
  
end