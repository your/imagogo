class Image < ActiveRecord::Base
  has_many :operations, dependent: :destroy
  
  def resize
    if !local_src.nil?
      OpWorker.resize_async(self.local_src, 140, 140)
    end
  end
  
end
