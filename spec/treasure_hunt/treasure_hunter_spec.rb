require 'spec_helper'

describe TreasureHunt::Hunter do
  before do
    User.delete_all
    @jane = User.create(:name => 'Jane')
    @joe = User.create(:name => 'Joe')
    @chosen_answer = ChosenAnswer.create(:answer_id => 1)
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

    it "should have target" do
      @jane.achievements.create(:reward => @reward, :targetable => @chosen_answer)

      @jane.achievements.last.targetable.should == @chosen_answer
    end

    it "should receive points" do
      @jane.achievements.size.should == 0
      3.times do
        @jane.achievements << Achievement.create(:reward => @reward)
      end
      @jane.reload
      @jane.points.should == 3*7

      last = @jane.achievements.last
      last.points = 5
      last.save

      @jane.reload
      @jane.points.should == 2*7 + 5

      @jane.achievements.destroy(last)

      @jane.reload
      @jane.points.should == 2*7
    end

    it "should get better rank" do
      User.count.should == 2

      @jane.rank.should == 1
      @joe.rank.should == 1

      @jane.achievements << Achievement.create(:reward => @reward)
      [@jane, @joe].each(&:reload)

      @jane.rank.should == 1
      @joe.rank.should == 2

      @joe.achievements << Achievement.create(:reward => @reward)
      [@jane, @joe].each(&:reload)

      @jane.rank.should == 1
      @joe.rank.should == 1

      @joe.achievements << Achievement.create(:reward => @reward)
      [@jane, @joe].each(&:reload)

      @jane.rank.should == 2
      @joe.rank.should == 1
    end
  end

  context "when using DSL" do
    before do
      Reward.delete_all
      @invite_friends = Reward.create(:name => 'Invite friends', :points => 50, :every => 1.day)
      @corret_answer = Reward.create(:name => 'Correct answer', :points => 50)
    end

    it "should achieve and lock reward" do
      @jane.can_achieve?(:invite_friends).should be_true
      @jane.achieve!(:invite_friends).should be_persisted
      @jane.reload
      @jane.points.should == 50
      @jane.can_achieve?(:invite_friends).should be_false
      @jane.time_to_unlock(:invite_friends).should <= 1.day
    end

    it "should achieve and log target" do
      @jane.can_achieve?(:correct_answer).should be_true
      @jane.achieve!(:correct_answer, @chosen_answer).should be_persisted
      @jane.achievements.last.targetable.should == @chosen_answer
    end
  end
end
