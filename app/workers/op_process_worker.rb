require 'grid'

class OpProcessWorker
  
  def initialize
    @operation = Operation.new(operation_type: 'process', status: 'running')
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
  
  def perform(image_id, image_src)
    
    @operation.update(image_id: image_id)
        
    image_0 = ChunkyPNG::Image.from_file(image_src)
    image_1 = image_0.flip_horizontally

    g_0 = Grid.new(image_0.height, 0)
    g_1 = Grid.new(image_1.height, 0)

    # fill grid
    i = 0; (image_0.width).times { g_0.inject_col(1, i, image_0.column(image_0.width-1-i), 0); i += 1; }
    i = 0; (image_1.width).times { g_1.inject_col(1, i, image_1.column(image_1.width-1-i), 0); i += 1; }

    # play
    100.times { g_0.inject_col(100, 50, g_1.pick_col(300), 0) }
    100.times { g_0.inject_col(100, 50-1, g_1.pick_col(200), -1) }
    i = 0; 100.times { g_0.inject_col(1, 50+50+i, g_1.pick_col(i+100), 0); i += 1; }
    i = 0; 100.times { g_0.swap_rows(50+25+i, i+100); i += 1; }

    # swap pixels
    i = 0; (image_0.width).times { image_0.replace_column!(i, g_0.pick_col(i)); i += 1; }

    # saving
    processed_src = image_src.rpartition('/')[0..-2].push("#{image_id}_processed.png").join('')
    image_0.save(processed_src)
    
    # ..in db too!
    ProcessedImage.new(local_src: processed_src, image_id: image_id).save
    
    @operation.update(status: 'ok')
  end
  
end