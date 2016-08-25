class AddTwitterFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_consumer_token, :string
    add_column :users, :twitter_consumer_secret, :string
    add_column :users, :twitter_raw_data, :string
  end
end
