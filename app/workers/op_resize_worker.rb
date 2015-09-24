require 'base64'
class OpResizeWorker
  
  def initialize
    @operation = Operation.new(operation_type: 'resize', status: 'running')
  end
  
  include Sidekiq::Worker
  
  #sidekiq_options retry: false
  sidekiq_options :retry => 1
  
  # The current retry count is yielded. The return value of the block must be 
  # an integer. It is used as the delay, in seconds. 
  sidekiq_retry_in do |count|
    10 * (count + 1) # (i.e. 10, 20, 30, 40)
  end
  
  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
    @operation.update(status: 'ko')
  end
  
  def perform(image_id, image_src, width, height)
    @operation.update(image_id: image_id)
    resized_src = image_src.rpartition('/')[0..-2].push("#{image_id}_resized.png").join('')
    image = MiniMagick::Image.open(image_src)
    image.resize "#{width}x#{height}"
    image.format "png"
    image.write resized_src
    Image.find_by_id(image_id).update(resized_src: resized_src)
    @operation.update(status: 'ok')
  end
end