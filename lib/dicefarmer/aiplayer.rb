module DiceFarmer
  class AIPlayer < Player
    attr_accessor ai_type

    def ai?
      true
    end

    def initialize(name, start_dice, ai_type = :pool)
      super(name, start_dice)
      @ai_type = ai_type
    end

    def ai_play_hand
      case ai_type
        when :pool
          make_most_dice
        when :sides
          make_biggest_dice
        end
      end
    end

    def make_most_dice

    end

    def make_biggest_dice

    end
    

  end
end
