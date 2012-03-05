require 'dicefarmer'

describe 'Die' do
  describe '#new' do
    it "accepts an integer argument for die sides" do
      @die = DiceFarmer::Die.new(4)
      @die.sides.should == 4
    end

    it "returns a Die" do
      @die = DiceFarmer::Die.new(4)
      @die.should be_a(DiceFarmer::Die)
    end

    it "set's the die's current_roll to 0" do
      @die = DiceFarmer::Die.new(4)
      @die.current_roll.should == 0
    end
  end

  describe '#roll' do
    it "returns an integer" do
      @die = DiceFarmer::Die.new(2)
      @die.roll.should be_an(Integer)
    end

    it "sets the current_roll attribute" do
      @die = DiceFarmer::Die.new(200)
      @die.roll.should == @die.current_roll
    end
  end

  describe "#dead?" do
    it "returns true if the current_roll is 1" do
      @die = DiceFarmer::Die.new(10)
      @die.current_roll = 1
      @die.dead?.should be_true
    end

    it "returns false if the current_roll is not 1" do
      @die = DiceFarmer::Die.new(10)
      @die.current_roll = 2
      @die.dead?.should be_false
    end
  end
  
end
