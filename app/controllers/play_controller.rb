class PlayController < ApplicationController
  def index
    @processed_images = ProcessedImage.all
    @last_operations = Operation.all.limit(10)
    @processing = Operation.all.where(status: 'running').joins(:image)
    
    p @processed_images
    p @last_operations
    p @processing
  end
end