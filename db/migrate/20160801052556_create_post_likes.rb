class CreatePostLikes < ActiveRecord::Migration
  def change
    create_table :post_likes do |t|
      t.references :post, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
