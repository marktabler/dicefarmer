module DiceFarmer

  class Die
    DENOMINATIONS = [4, 6, 8, 10, 12, 20]
    attr_accessor :sides, :current_roll

    def initialize(sides)
      @sides = sides
      @current_roll = 0
    end

    def roll
      @current_roll = (rand * @sides + 1).to_i
    end

    def dead?
      @current_roll == 1
    end

    # Dice get moved to the back of the list if their roll is 0.
    # In this way, new dice that get added to the mix get pushed to
    # the back of the line and do not affect the order of the existing
    # list.
    def <=>(other)
      if other.current_roll == 0
        -1
      elsif current_roll == 0
        1
      else
        sides <=> other.sides
      end
    end
    
    
  end
    
end
