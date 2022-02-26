require 'colorize'
require_relative 'board.rb'
class Chess_Game

    def initialize
        @playerone = "white"
        @playertwo = "black"
        @current_player = nil
        @game = ChessBoard.new
        @game_end = false
        intro
        while @game_end == false
            player_turns
            @game.player_on(@current_player)
            @game.display_board
            @game.select_piece
            @game.move
            
        end
        puts "Thanks For Playing!"
    end

    def player_turns(player = @current_player)
        if player == nil || player == @playertwo
            @current_player = @playerone
        else
            @current_player = @playertwo
        end
    end

    def intro
        puts "This Project Is From TheOdinProject Curriculum"
        puts "i'm Not Really Good At Chess So If I Missed Something Let me Know\n I Didn't Add The En-pessant Move yet So Sorry To Disapoint You\n Chess GEEKS! \nSo Lets Begin"
        puts "Thanks For Playing!"
        puts "My Github: https://github.com/Marwan515"
    end
end

start_game = Chess_Game.new
start_game