module TreasureHunt
  module Achievement
    extend ActiveSupport::Concern

    included do
      attr_accessible :user_id, :reward_id, :points, :targetable_id, :targetable_type

      belongs_to :user
      belongs_to :reward
      belongs_to :targetable, :polymorphic => true

      validates_associated :user, :reward
      validates_presence_of :user, :reward

      validate :reward_cannot_be_achieved_above_limits

      before_save :fill_points

      after_save :update_user_points
      after_destroy :update_user_points
    end

    module ClassMethods

    end

    module InstanceMethods
      def fill_points
        self.points = self.reward.points unless self.points
      end

      # TODO refactoring to Validator
      def reward_cannot_be_achieved_above_limits
        limit = self.reward.limit rescue 1.0/0

        if self.find_all_similar_and_younger.size >= limit
          errors.add(:reward, "can't achieve reward at current time")
        end
      end

      def find_all_similar
        ret =  self.class.where(:user_id => self.user_id, :reward_id => self.reward_id).order('updated_at DESC')
        ret = ret.where('id != ?', self.id) if self.id

        ret
      end

      def find_all_similar_and_younger
        age = Time.now - self.reward.every rescue 0

        find_all_similar.where('updated_at > ?', age)
      end

      def find_all_recently_achieved
        limit = self.reward.limit rescue 1.0/0 # Yep, that's Infinity

        find_all_similar_and_younger.limit(limit)
      end

    end

    private
    def update_user_points
      self.user.update_points
    end

  end
end
