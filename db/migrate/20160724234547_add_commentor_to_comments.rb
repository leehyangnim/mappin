class AddCommentorToComments < ActiveRecord::Migration
  def change
    add_column :comments, :commentor, :string
  end
end
