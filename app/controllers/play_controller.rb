class PlayController < ApplicationController
  
  def new
    @image = Image.new
  end
  
  def create
    upload_params = params[:upload][:image]
    @image = Image.new
    @image.save
    @image.upload(upload_params)
    redirect_to play_index_path
  end
  
  def index
    @processed_images = ProcessedImage.all
    @last_operations = Operation.all.limit(10)
    @processing = Operation.all.where(status: 'running').joins(:image)
    
    p @processed_images
    p @last_operations
    p @processing
  end
  
end