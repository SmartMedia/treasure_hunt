module TreasureHunt
  module Reward
    extend ActiveSupport::Concern

    included do
      attr_accessible :name, :points, :limit, :every

      has_many :achievements

      validates_presence_of :name
      validates_uniqueness_of :name
    end

    module ClassMethods

    end

    module InstanceMethods

    end

  end
end
