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

        def rank
          self.class.count(:all, :conditions => ['points > ?', self.points]) + 1
        end

        def update_points
          self.update_attribute(:points, self.achievements.sum(:points))
        end

        def can_achieve?(reward)
          reward = ::Reward.find_by_name(reward.to_s.humanize) if reward.is_a? Symbol

          ::Achievement.new(:user => self, :reward => reward).valid?
        end

        def achieve!(reward, target=nil)
          reward = ::Reward.find_by_name(reward.to_s.humanize) if reward.is_a? Symbol
          achievement = ::Achievement.create(:reward => reward, :targetable => target)
          self.achievements << achievement

          achievement
        end

        def time_to_unlock(reward)
          reward = ::Reward.find_by_name(reward.to_s.humanize) if reward.is_a? Symbol
          achievement = ::Achievement.new(:user => self, :reward => reward)
          remaining = (achievement.find_all_recently_achieved.last.updated_at rescue DateTime.new ) + reward.every.seconds - DateTime.now

          [0, remaining].max
        end

        def has_achievement?(reward)
          reward = ::Reward.find_by_name(reward.to_s.humanize) if reward.is_a? Symbol
          achievements.where(:reward_id => reward.id).any?
        end
      end
    end

  end
end
