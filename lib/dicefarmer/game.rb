module DiceFarmer

  class Game

    attr_accessor :start_dice, :goal_dice, :players, :current_player, :game_over

    def initialize(start_dice, goal_dice, player_count)
      @game_over = false
      @start_dice = start_dice
      @goal_dice = goal_dice
      make_players(player_count)
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
      score_check = goal_dice
      player.dice.map(&:sides).each do |die|
        if score_check.include?(die)
          score_check.delete(die)
        end
      end
      score_check.empty?
    end

    def play
      until @game_over
        @current_player ||= 0
        manage_turn(@players[@current_player])
        @current_player += 1
        current_player = 0 if current_player > @players.size
      end
    end
    
    def manage_turn(player)
      puts "Your turn, #{player.name}"
      player.roll
      display_roll_results(player)
      puts "Discarding dead dice."
      player.discard_dead_dice
      accept_die_decisions(player)
      win_game(player) if player_won?(player)
    end

    def display_roll_results(player)
      @player.dice.sort_by {|d| d.sides}.each_with_index do |die, index|
        puts "#{index + 1}: D#{die.sides} : #{die.current_roll}"
      end
    end
    
    def accept_die_decisions(player)
      display_roll_results(player)
      puts "Which dice would you like to combine?"
      die_selections = gets.chomp
      if die_selections.size >= 1
        parse_decision(die_selections, player)
        accept_die_decisions(player)
      end
    end
    
    
    def parse_decisions(die_selections, player)
      indexes = die_selections.split(',').map(&:to_i).compact.uniq
      if indexes.select{|i| i < 1}.any? || indexes.select{|i| i > player.dice.size}.any?
        puts "Error in input; please try again."
      else
        selections = []
        indexes.each do |index|
          selections << player.dice.sort_by {|d| d.sides}[index - 1]
        end
        player.make_new_dice(selections)
      end
    end
    
    def win_game(player)
      "#{player.name} has won the game!"
      @game_over = true
    end
    
  end
end
