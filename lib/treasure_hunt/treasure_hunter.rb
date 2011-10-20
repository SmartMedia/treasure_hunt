module TreasureHunt
  module Hunter

    def acts_as_treasure_hunter
      include TreasureHunt::Hunter::Model
    end

    module Model
      extend ActiveSupport::Concern

      included do
        has_many :achievements
        has_many :rewards, :through => :achievements
      end

      module ClassMethods

      end

      module InstanceMethods

        def points
          self.achievements.collect(&:points).sum rescue 0
        end

      end
    end

  end
end
