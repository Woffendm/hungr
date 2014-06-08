class CreateOpinions < ActiveRecord::Migration
  def change
    create_table :opinions do |t|
      t.integer :user_id
      t.integer :restaurant_id
      t.integer :like

      t.timestamps
    end
  end
end
