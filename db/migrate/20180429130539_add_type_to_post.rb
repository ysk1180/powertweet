class AddTypeToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :type, :string
  end
end
