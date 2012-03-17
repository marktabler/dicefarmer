module DiceFarmer
  class Player

    attr_accessor :name, :dice
    
    def initialize(name, start_dice)
      @name = name
      clear_dice
      add_dice(start_dice)
    end

    def ai?
      false
    end

    def add_dice(dice_values)
      dice_values.each do |value|
        add_die(value)
      end
    end

    def add_die(die_value)
      @dice << DiceFarmer::Die.new(die_value)
    end

    # A freshly added die will have a current_roll of 0.
    # This allows current_hand to return only dice that
    # have actually been rolled.
    def current_hand
      @dice.map(&:current_roll).reject { |r| r == 0 }
    end
    
    def clear_dice
      @dice = []
    end
    
    def roll
      @dice.each do |die|
        die.roll
      end
    end

    def discard_dead_dice
      @dice.reject!{|die| die.dead?}
    end

    def make_new_die(dice)
      total = dice.map(&:current_roll).inject(:+)
      if DiceFarmer::Die::DENOMINATIONS.include?(total)
        dice.each do |die|
          die.current_roll = 0
        end
        add_die(total)
        "I made you a new die with #{total} sides."
      else
        "I can't make a die with #{total} sides."
      end
    end

    def busted?
      @dice.size == 0
    end
    
  end
end
