class Comment < ApplicationRecord
	belongs_to :article

	scope :latest_comments, -> { order(created_at: :desc).limit(5) }

	validates :comment, presence: true
end