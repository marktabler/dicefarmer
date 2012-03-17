module DiceFarmer

  class Game

    attr_accessor :start_dice, :goal_dice, :players, :current_player, :game_over

    def initialize(start_dice, goal_dice, player_count)
      @game_over = false
      @start_dice = start_dice
      @goal_dice = goal_dice
      welcome_script
      make_players(player_count)
    end

    def welcome_script
      puts "\n"
      puts "Welcome to Dice Farmer!"
      puts "\n"
      puts "You start the game with a handful of dice."
      puts "Each turn, you roll all of your dice."
      puts "Dice that come up 1 are 'dead', and get discarded."
      puts "Everything else becomes part of a pool you can make new dice with!"
      puts "You can use individual dice or group them together; either way, the"
      puts "results must total 4, 6, 8, 10, 12, or 20. You will get a new die"
      puts "for your next turn with that many sides."
      puts "You can make as many dice as you have results for each turn."
      puts "Dice that don't get used are simply ignored and re-rolled next turn."
      puts "First person to get a certain number of dice of a certain size wins!"
      puts "On your turn, you will be asked to pick dice to combine."
      puts "The game accepts input like this: 1,2,4"
      puts "That command will add the results of dice 1, 2, and 4, and make"
      puts "a new die with that many faces."
      puts "\n"
      puts "This game will start with these dice:"
      puts @start_dice.map(&:to_s).join(", ")
      puts "The winner is the first person to reach these dice:"
      puts @goal_dice.map(&:to_s).join(", ")
    end
    
    def make_players(player_count)
      @players = []
      player_count.times do
        puts "Enter name for player #{@players.size + 1}"
        name = gets.chomp
        @players << DiceFarmer::Player.new(name, start_dice)
      end
    end

    def player_won?(player)
      has_won = true
      DiceFarmer::Die::DENOMINATIONS.each do |denom|
        if goal_dice.include?(denom)
          goal_dice_size = goal_dice.select{|d| d == denom}.size
          player_dice_size = player.dice.map(&:sides).select{|d| d == denom}.size
          has_won = false if player_dice_size < goal_dice_size
        end            
      end
      has_won
    end

    def play
      until @game_over
        @current_player ||= 0
        manage_turn(@players[@current_player])
        @current_player += 1
        @current_player = 0 if @current_player >= @players.size
      end
    end
    
    def manage_turn(player)
      puts "Your turn, #{player.name}"
      player.roll
      display_roll_results(player)
      puts "Discarding dead dice."
      player.discard_dead_dice
      accept_die_decisions(player) unless player.busted?
      win_game(player) if player_won?(player)
      bounce_back(player) if player.busted?
    end

    def bounce_back(player)
      puts "#{player.name}, you busted! We'll get you back in the game."
      player.add_dice(start_dice)
    end
    
    def display_roll_results(player)
      player.dice.sort.each_with_index do |die, index|
        puts "#{index + 1}: D#{die.sides} : #{die.current_roll}" unless die.current_roll == 0
      end
    end
    
    def accept_die_decisions(player)
      if player.ai?
        die_selections = player.ai_play_hand
      else
        die_selections = get_human_decisions(player)
      end
      
      if die_selections.size >= 1
        parse_decisions(die_selections, player)
        accept_die_decisions(player)
      end
    end
    
    def get_human_decisons(player)
      display_roll_results(player)
      puts "Make a new die from which results? (Enter to end turn)"
      return gets.chomp
    end

    # Takes input in the form "1,2,4" or "1, 2, 4", and matches
    # the selections up to die indexes
    def parse_decisions(die_selections, player)
      indexes = die_selections.split(',').map(&:to_i).compact.uniq
      if indexes.select{|i| i < 1}.any? || indexes.select{|i| i > player.dice.size}.any?
        puts "Error in input; please try again."
      else
        selections = []
        indexes.each do |index|
          selections << player.dice.sort[index - 1]
        end
        puts player.make_new_die(selections)
      end
    end
    
    def win_game(player)
      puts "Game over! #{player.name} has won the game!"
      @game_over = true
    end
    
  end
end
