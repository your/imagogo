class Image < ActiveRecord::Base
  has_many :operations, dependent: :destroy
  has_one :converted_image, dependent: :destroy
  
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
