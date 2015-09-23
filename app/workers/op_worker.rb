class OpWorker
  include Sidekiq::Worker
  def resize(image_local, width, height)
  end
end