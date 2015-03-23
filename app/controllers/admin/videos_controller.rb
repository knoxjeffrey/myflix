class Admin::VideosController < AdminsController
  
  def new
    @video = Video.new
  end
  
  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "You have successfully added #{@video.title}."
      redirect_to admin_add_video_path
    else
      render :new
    end
  end
  
  private
  
  def video_params
    params.require(:video).permit(:title, :category_id, :description, :small_cover, :large_cover)
  end
  
end