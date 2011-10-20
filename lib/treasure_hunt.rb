require 'treasure_hunt/treasure_hunter'
ActiveRecord::Base.send :extend, TreasureHunt::Hunter
