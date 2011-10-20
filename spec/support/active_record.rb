ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => ":memory:"
)

ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users, :force => true do |t|
    t.string :name, :null => false
  end

  create_table :achievements, :force => true do |t|
    t.references :user
    t.references :reward
    t.integer :points
    t.timestamps
  end

  create_table :rewards, :force => true do |t|
    t.string :name, :null => false
    t.integer :points, :default => 0, :null => false
    t.integer :every, :default => 0, :null => false
    t.integer :limit, :default => 1, :null => false
  end
end

class User < ActiveRecord::Base
  acts_as_treasure_hunter
end

class Achievement < ActiveRecord::Base
  include TreasureHunt::Achievement
end

class Reward < ActiveRecord::Base
  include TreasureHunt::Reward
end
