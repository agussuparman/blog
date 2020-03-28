class ArticlesController < ApplicationController
	before_action :set_article, only: [:show, :edit, :update, :destroy]
	before_action :set_categories, only: [:new, :create, :edit, :update]

	def index
		# @articles = Article.all
		# Article.order_by_created_at
		page = params[:page] || 1
		@articles = Article.search('*', load: false, page: page, per_page: 25, order: { id: :desc })
	end

	def show
		@comment = Comment.new
	end

	def new
		@article = Article.new
	end

	def create
		@article = Article.new(article_params)
		if @article.save
			# ArticleMailer.new_article(@article.id).deliver_now
			NewArticleEmailNotificationWorker.perform_async(@article.id)
			Article.search_index.refresh
			redirect_to articles_path
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @article.update(article_params)
			Article.search_index.refresh
			redirect_to articles_path
		else
			render 'edit'
		end
	end

	def destroy
		if @aticle.destroy
			Article.search_index.refresh
			redirect_to articles_path
		end
	end

	private

	def set_article
		@article = Article.find(params[:id])
	end

	def set_categories
		# @categories = Category.all.map do |category|
		# 	[category.name, category.id]
		# end
		@categories = $redis.hgetall("categories").map { |e| JSON(e[1]) }.map { |e| [e["name"], e["id"]] }
	end

	def article_params
		params.require(:article).permit(:title, :description, :category_id)
	end
end