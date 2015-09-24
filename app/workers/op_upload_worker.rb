require "base64"
class OpUploadWorker
    
  def initialize
    @operation = Operation.new(operation_type: 'upload', status: 'running')
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
  
  def perform(image_id, original_filename, file_read)
    @operation.update(image_id: image_id)
    file_read = Base64.decode64(file_read)
    File.open(Rails.root.join('public', 'imgs', original_filename), 'wb') do |file|
      file.write(file_read)
    end
    i = Image.find_by_id(image_id)
    i.update(local_src: "public/imgs/#{original_filename}")
    @operation.update(status: 'ok')
    i.resize
  end
end