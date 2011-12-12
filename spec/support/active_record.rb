ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => ":memory:"
)

ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users, :force => true do |t|
    t.string :name, :null => false
    t.integer :points, :default => 0, :null => false
  end

  create_table :achievements, :force => true do |t|
    t.references :user
    t.references :reward
    t.integer :points
    t.references :targetable, :polymorphic => true
    t.timestamps
  end

  create_table :rewards, :force => true do |t|
    t.string :name, :null => false
    t.integer :points, :default => 0, :null => false
    t.integer :every, :default => 0, :null => false
    t.integer :limit, :default => 1, :null => false
  end

  create_table :chosen_answers, :force => true do |t|
    t.integer :answer_id
  end
end

class User < ActiveRecord::Base
  acts_as_treasure_hunter
end

class Achievement < ActiveRecord::Base
  include TreasureHunt::Achievement

  has_one :chosen_answer, :as => :targetable
end

class Reward < ActiveRecord::Base
  include TreasureHunt::Reward
end

class ChosenAnswer < ActiveRecord::Base
end
