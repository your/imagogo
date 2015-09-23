class Image < ActiveRecord::Base
  has_many :operations, dependent: :destroy
end
