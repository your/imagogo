class OpResizeWorker
  
  include Sidekiq::Worker
  
  sidekiq_options retry: false
  
  def perform(image_id, image_src, width, height)
    resized_src = image_src.rpartition('/')[0..-2].push("#{image_id}_resized.png").join('')
    image = MiniMagick::Image.open(image_src)
    image.resize "#{width}x#{height}"
    image.format "png"
    image.write resized_src
    Image.find_by_id(image_id).update(resized_src: resized_src)
  end
end