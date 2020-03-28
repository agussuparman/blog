class ArticleMailer < ApplicationMailer
	def new_article(id)
		article = Article.find(id)

		@title = article.title
		@description = article.description
		
		mail to: "agus.soeparmans@gmail.com"
	end
end