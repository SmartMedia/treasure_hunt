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
  end

  create_table :rewards, :force => true do |t|
    t.string :name, :null => false
    t.integer :points
    t.integer :every
    t.integer :limit
  end
end

class User < ActiveRecord::Base
  acts_as_treasure_hunter
end

class Achievement < ActiveRecord::Base
  belongs_to :user
  belongs_to :reward

  # TODO remove this
  before_save Proc.new {|achievement| achievement.points = achievement.reward.points}
end

class Reward < ActiveRecord::Base
  has_many :achievements
end
