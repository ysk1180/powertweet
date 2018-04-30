class AddColumnToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :oauth_token, :string
    add_column :posts, :oauth_token_secret, :string
  end
end
