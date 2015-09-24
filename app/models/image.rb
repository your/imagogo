require 'base64'
class Image < ActiveRecord::Base
  has_many :operations, dependent: :destroy
  has_one :processed_image, dependent: :destroy
    
  def upload(upload_params)
    file_name = upload_params.original_filename
    file_content = Base64.encode64(upload_params.read).force_encoding('UTF-8')
    OpUploadWorker.perform_async(self.id, file_name, file_content)
  end

  def resize
    if !local_src.nil?
      OpResizeWorker.perform_async(self.id, self.local_src, 540, 540)
    end
  end
  
  def process
    if !resized_src.nil?
      OpProcessWorker.perform_async(self.id, self.resized_src)
    end
  end
  
end
