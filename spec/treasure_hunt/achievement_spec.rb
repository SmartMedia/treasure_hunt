require 'spec_helper'

describe TreasureHunt::Achievement do
  before do
    User.delete_all
    Reward.delete_all
    @joe = User.create(:name => 'Joe')
    @win = Reward.create(:name => 'Win!', :points => 42)
  end

  context "when creating achievement" do
    it "should validate foreign keys" do
      achievement = Achievement.new
      achievement.should_not be_valid
      achievement.errors.should include(:user)
      achievement.errors.should include(:reward)
      achievement.errors.size.should == 2

      achievement.user = @joe
      achievement.should_not be_valid
      achievement.errors.should include(:reward)
      achievement.errors.size.should == 1

      achievement.reward = @win
      achievement.should be_valid
    end

    it "should have same points as reward" do
      achievement = Achievement.create(:user => @joe, :reward => @win)
      achievement.points.should == 42
    end

    it "should not change points if set when creating" do
      achievement = Achievement.create(:user => @joe, :reward => @win, :points => 13)
      achievement.new_record?.should be_false
      achievement.points.should == 13
    end
  end

  context "when validating if achievement is possible" do
    before do
      @one_per_day = Reward.create(:name => 'One per day', :every => 1.day, :limit => 1)
      @three_per_day = Reward.create(:name => 'Three per day', :every => 1.day, :limit => 3)
    end

    it "should not allow 2 one-per-day in the same day" do
      first = Achievement.create(:user => @joe, :reward => @one_per_day)
      first.should be_valid

      second = Achievement.new(:user => @joe, :reward => @one_per_day)
      second.should_not be_valid
    end

    it "should allow 2 on-per-day after 1 day" do
      first = Achievement.create(:user => @joe, :reward => @one_per_day, :created_at => 1.day.ago, :updated_at => 1.day.ago)
      first.should be_valid

      second = Achievement.create(:user => @joe, :reward => @one_per_day)
      second.should be_valid
    end

    it "should allow 3 three-per-day in the same day" do
      3.times do
        Achievement.create(:user => @joe, :reward => @three_per_day).should be_valid
      end
    end

    it "should not allow 4 three-per-day in the same day" do
      3.times do
        Achievement.create(:user => @joe, :reward => @three_per_day).should be_valid
      end
      Achievement.create(:user => @joe, :reward => @three_per_day).should_not be_valid
    end
  end
end
