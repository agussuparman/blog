class NewArticleEmailNotificationWorker
	include Sidekiq::Worker

	def perform(id)
		ArticleMailer.new_article(id).deliver_now
	end
end