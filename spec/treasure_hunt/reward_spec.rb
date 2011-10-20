require 'spec_helper'

describe Reward do
  context "when creating reward" do
    it "should validate presence of name" do
      reward = Reward.new
      reward.valid?.should be_false
      reward.errors.should include(:name)
      reward.errors.size.should == 1

      reward.name = 'You won!'
      reward.valid?.should be_true
    end

    it "should have default value 0 for :points, :every and 1 for :limit" do
      reward = Reward.create(:name => 'Meaningless reward')
      reward.points.should == 0
      reward.limit.should == 1
      reward.every.should == 0
    end
  end
end
