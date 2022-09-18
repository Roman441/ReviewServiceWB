class GetFeedbackWorker
  include Sidekiq::Worker

  def perform
    Wildberries::FeedbacksImporter.import
  end
end
