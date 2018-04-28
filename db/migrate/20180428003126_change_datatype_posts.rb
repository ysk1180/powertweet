class ChangeDatatypePosts < ActiveRecord::Migration[5.2]
  def change
    change_column :posts, :content, :text
    change_column :posts, :power, :text
  end
end
