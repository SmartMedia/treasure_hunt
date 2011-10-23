class CreateTreasureHuntTables < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.references :user
      t.references :reward
      t.integer :points

      t.timestamps
    end
    add_index :achievements, :user_id
    add_index :achievements, :reward_id

    create_table :rewards do |t|
      t.string :name
      t.integer :points, :default => 0, :null => false
      t.integer :every, :default => 0, :null => false
      t.integer :limit, :default => 1, :null => false

      t.timestamps
    end
  end
end
