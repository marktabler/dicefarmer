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
    
  end
    
end
