class AddCategoryIdToArticles < ActiveRecord::Migration[5.2]
  def change
  	add_reference :articles, :category, index: true, foreign_key: true
  end
end
