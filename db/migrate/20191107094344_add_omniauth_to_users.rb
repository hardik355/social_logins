class AddOmniauthToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :oauth_token, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :oauth_expires_at, :datetime
    add_column :users, :oauth_user_name, :string
  end
end
