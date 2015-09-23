class Image < ActiveRecord::Base
  has_many :operations, dependent: :destroy
  
  def resize
    if !local_src.nil?
      OpResizeWorker.perform_async(self.local_src, 140, 140)
    end
  end
  
end
