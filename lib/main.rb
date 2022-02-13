require_relative 'board.rb'

class Chess_Game

    def initialize
        @playerone = "white"
        @playertwo = "black"
        @current_player = nil
        @selected_piece = nil
    end

    def player_turns(player = @current_player)
        if player == nil
            @current_player = @playerone
        else
            @current_player @playertwo
        end
    end

end