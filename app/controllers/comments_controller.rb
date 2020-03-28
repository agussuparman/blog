class CommentsController < ApplicationController
	def create
		@comment = Comment.new(comment_params)
		@article = Article.find(params[:article_id])
		@comment.article = @article
		if @comment.save
			# Article.search_index.refresh
			Article.reindex
			redirect_to articles_path
		else
			render 'articles/show'
		end
	end

	private

	def comment_params
		params.require(:comment).permit(:article_id, :comment)
	end
end