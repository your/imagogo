class PlayController < ApplicationController
  
  def new
    @image = Image.new
  end
  
  def create
    upload_params = params[:upload][:image]
    @image = Image.new
    @image.save
    @image.upload(upload_params)
    redirect_to unprocessed_path
  end
  
  def unprocessed
    @unprocessed_images = Image.joins("LEFT JOIN processed_images ON images.id = processed_images.image_id WHERE processed_images.image_id IS NULL")
    p @unprocessed_images
  end
  
  def index
    @processed_images = ProcessedImage.all.order('id DESC')
    @last_operations = Operation.all.limit(10)
    @processing = Operation.all.where(status: 'running').joins(:image)
    
    p @processed_images
    p @last_operations
    p @processing
  end
  
  def processs
    image_id = params[:id]
    i = Image.find_by_id(image_id)
    i.process
    
    respond_to do |format|
      format.json { render :json => 'yeah' }
    end
  end
end