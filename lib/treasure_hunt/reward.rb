module TreasureHunt
  module Reward
    extend ActiveSupport::Concern

    included do
      has_many :achievements

      validates_presence_of :name
    end

    module ClassMethods

    end

    module InstanceMethods

    end

  end
end
