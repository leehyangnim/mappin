class AddFacebookOauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_token, :string
    add_column :users, :facebook_raw_data, :text
    add_column :users, :facebook_expires_at, :integer
  end
end
