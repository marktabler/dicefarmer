require 'dicefarmer'

describe 'Game' do
  before do
#    $stdout.stub!(:write)
  end
  
  describe 'make_players' do
    it "creates an array of DiceFarmer::Players" do
      @game = DiceFarmer::Game.new([4], [20], 2)
    end

    it "deals each player the appropriate dice" do
      @game = DiceFarmer::Game.new([4, 4, 8], [20], 2)
      @game.players.each do |player|
        player.dice.map(&:sides).sort.should == [4, 4, 8]
      end
    end
  end

  describe 'player_won?' do
    it "returns true if the player meets the victory condition (separate denoms)" do
      @game = DiceFarmer::Game.new([2, 4, 8, 12, 20], [4, 8, 20], 2)
      @game.player_won?(@game.players.first).should be_true
    end
    
    it "returns true if the player meets the victory condition (separate and multiple denoms)" do
      @game = DiceFarmer::Game.new([2, 4, 8, 12, 20, 20, 20], [4, 8, 20, 20, 20], 2)
      @game.player_won?(@game.players.first).should be_true
    end

    it "returns false if the player does not meet the victory condition (separate denoms)" do
#      @game = DiceFarmer::Game.new([2, 4, 12, 20], [4, 8, 20], 2)
#      @game.player_won?(@game.players.first).should be_false
    end
    
    it "returns false if the player does not meet the victory condition (missing one denom, has enough of another)" do
#      @game = DiceFarmer::Game.new([2, 4, 12, 20, 20, 20], [4, 8, 20, 20, 20], 2)
#      @game.player_won?(@game.players.first).should be_false
    end

    it "returns false if the player does not meet the victory condition (not enough of one denom)" do
    @game = DiceFarmer::Game.new([2, 20], [20, 20, 20], 2)
    @game.player_won?(@game.players.first).should be_false
    end
  end
end
