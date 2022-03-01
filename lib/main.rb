require 'colorize'
require_relative 'board.rb'
class Chess_Game

    def initialize
        intro
        @playerone = "white"
        @playertwo = "black"
        @current_player = nil
        @game = ChessBoard.new
        @loaded_player = @game.ply
        @end = @game.en_game
        while @end != true
            if !@loaded_player.nil?
                @current_player = @loaded_player
                @loaded_player = nil
            else
                player_turns
            end
            @game.player_on(@current_player)
            @game.display_board
            @game.select_piece
            @end = @game.en_game
            if @end == true
                next
            end
            @game.move
        end
        puts "Thanks For Playing!"
    end

    def player_turns(one = nil, player = @current_player)
        if !one.nil?
            player = one
        elsif player == nil || player == @playertwo
            @current_player = @playerone
        else
            @current_player = @playertwo
        end
    end

    def intro
        puts "This Project Is From TheOdinProject Curriculum"
        puts "i'm Not Really Good At Chess So If I Missed Something Let me Know\nI Didn't Add The En-pessant Move yet So Sorry To Disapoint You\nChess GM's! \nSo Lets Begin The Journey OF Becoming CHESS GRANDMASTER -> \u265a"
        puts "Thanks For Playing!"
        puts "My Github: https://github.com/Marwan515"
    end
end

start_game = Chess_Game.new
start_game