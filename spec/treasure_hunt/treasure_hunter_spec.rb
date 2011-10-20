require 'spec_helper'

describe TreasureHunt::Hunter do
  before do
    @jane = User.create(:name => 'Jane')
    @joe = User.create(:name => 'Joe')
  end

  context "when achieved something" do
    before do
      Reward.delete_all
      (@reward = Reward.create(:name => 'Win!', :points => 7)).should be_valid
    end

    it "should have reward" do
      @jane.achievements.create(:reward => @reward)

      @jane.rewards.should =~ [@reward]
    end

    it "should receive points" do
      @jane.achievements.size.should == 0
      3.times do
        @jane.achievements << Achievement.create(:reward => @reward)
      end
      @jane.reload
      @jane.points.should == 3*7
    end
  end
end
