class Category < ApplicationRecord
	has_many :articles

	after_save :cache_to_redis
	before_destroy :flush_from_redis

	validates :name, presence: true

	def set_key
		self.class.to_s.pluralize.downcase
	end

	def set_field
		"#{self.class.to_s.singularize.downcase}_#{self.id}"
	end

	def cache_to_redis
		$redis.hset(set_key, self.set_field, { id: self.id, name: self.name }.to_json)
	end

	def get_from_redis
		$redis.hget(set_key, self.set_field)
	end

	def flush_from_redis
		$redis.hdel(set_key, self.set_field)
	end

	def to_s
		name
	end
end