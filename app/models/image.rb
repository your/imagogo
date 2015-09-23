class Image < ActiveRecord::Base
  has_many :operations, dependent: :destroy
  
  def resize
    if !local_src.nil?
      OpResizeWorker.perform_async(self.id, self.local_src, 540, 540)
    end
  end
  
end
