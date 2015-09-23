class Image < ActiveRecord::Base
  has_many :conversions, dependent: :destroy
end
