module ChessMoves
    include ChessBoard
    include Pieces

    def initialize
        @splayer = nil
        @knight_m = [[2, 1], [2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2], [-2, 1], [-2, -1]]
    end

    def cur_player(player)
        @splayer = player
    end

    # check i-f the pawn is in the start position so it can upto 2 tiles if wanted
    def pawn_start_pos(cols)
        if cols == 1 || cols == 7
            true
        end
    end
    
    # pawns Possible Moves
    def pawns(cols)
        if @splayer == "white"
            if pawn_start_pos(cols)
                pos = [[2], [1]]
                pos
            else
                pos = [[1, 1], [1, -1]]
                pos
            end
        elsif @splayer == "black"
            if pawn_start_pos(cols)
                pos = [[-2], [-1]]
                pos
            else
                pos = [[-1, -1], [-1, 1]]
                pos
            end
        end
    end
        
    

end