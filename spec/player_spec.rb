require 'dicefarmer'

describe 'Player' do
  describe '#initialize' do
    it "accepts a name and an array of starting die sizes" do
      @player = DiceFarmer::Player.new("Joe", [6, 6, 6])
      @player.name.should == "Joe"
      @player.dice.map(&:sides).should == [6, 6, 6]
    end
  end

  describe '#roll' do
    it "rolls each of the dice in a player's hand" do
      @player = DiceFarmer::Player.new("Joe", [2, 2, 2])
      @player.dice.each do |die|
        die.current_roll = 0
      end
      @player.roll
      @player.current_hand.include?(0).should be_false
    end
  end

  describe "#discard_dead_dice" do
    it "discards each die with a current_roll of 1" do
      @player = DiceFarmer::Player.new("Joe", [2, 2, 2])
      @player.dice.each do |die|
        die.current_roll = 0
      end
      @player.dice.first.current_roll = 1
      @player.discard_dead_dice
      @player.dice.size.should == 2
    end

    it "does not discard any die with a current_roll other than 1" do
      @player = DiceFarmer::Player.new("Joe", [2, 2, 2])
      @player.dice.each do |die|
        die.current_roll = 2
      end
      @player.discard_dead_dice
      @player.dice.size.should == 3      
    end
  end

  describe "#busted?" do
    it "returns true if the player's hand is empty" do
      @player = DiceFarmer::Player.new("Joe", [])
      @player.busted?.should be_true
    end

    it "returns false if the player's hand has any dice" do
      @player = DiceFarmer::Player.new("Joe", [2, 2, 2])
      @player.busted?.should be_false
    end
    
  end
  

  describe "#make_new_die" do

    it "accepts an array of dice" do
      @player = DiceFarmer::Player.new("Joe", [4, 4, 4])
      @player.dice.each do |die|
        die.current_roll = 3
      end
      @player.make_new_die([@player.dice[0], @player.dice[1]])
    end
    
    it "makes a new die out of a valid total" do
      @player = DiceFarmer::Player.new("Joe", [4, 4, 4])
      @player.dice.each do |die|
        die.current_roll = 3
      end
      @player.make_new_die([@player.dice[0], @player.dice[1]])
      @player.dice.map(&:sides).include?(6).should be_true
    end

    it "discards dice used to make the new die" do
      @player = DiceFarmer::Player.new("Joe", [4, 4, 4])
      @player.dice.each do |die|
        die.current_roll = 3
      end
      @player.make_new_die([@player.dice[0], @player.dice[1]])
      @player.dice.map(&:sides).sort.should == [4, 6]
    end
        
    it "rejects totals other than standard die sizes" do
        @player = DiceFarmer::Player.new("Joe", [4, 4, 4])
      @player.dice.each do |die|
        die.current_roll = 3
      end
      @player.make_new_die(@player.dice).should == "I can't make a die with 9 sides."
      @player.dice.map(&:sides).should == [4, 4, 4]
    end
    
  end
  
  
end
