class RemobeColumnToUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :oauth_token, :string
    remove_column :posts, :oauth_token_secret, :string
  end
end
