class OpResizeWorker
  include Sidekiq::Worker
  def perform(image_local, width, height)
    image = MiniMagick::Image.new(image_local) do |b|
      b.resize "#{width}x#{height}>"
      b.format "png"
      b.write(image_local)
    end
  end
end