class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :content
      t.string :power
      t.integer :user_id
      t.string :picture

      t.timestamps
    end
  end
end
