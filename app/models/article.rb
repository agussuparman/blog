class Article < ApplicationRecord
	searchkick

	# scope :order_by_created_at, -> { order(title: :desc) }

	belongs_to :category
	has_many :comments, dependent: :destroy

	validates :title, presence: true
	validates :description, presence: true
	validates :category_id, presence: true

	def search_data
		{
			title: title,
			description: description,
			category: category.name,
			comments_count: self.comments.size,
			latest_comments: self.comments.latest_comments.map(&:comment)
		}
	end
end