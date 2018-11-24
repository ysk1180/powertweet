class CreateReadUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :read_users do |t|
      t.string :line_id, null: false

      t.timestamps
    end
  end
end
