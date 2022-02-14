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
        if cols == 1 || cols == 6
            true
        end
        false
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
    # rooks possible moves
    def rook_m(cols, rows)
        i = rows
        right_w = 0
        left_w = 0
        top_w = 0
        down_w = 0
        until !empty_tile(cols, i)
            i += 1
            right_w += 1
        end
        i = rows
        until !empty_tile(cols, i)
            i -= 1
            left_w += 1
        end
        i = cols
        until !empty_tile(i, rows)
            i += 1
            top_w += 1
        end
        i = cols
        until !empty_tile(i, rows)
            i -= 1
            down_w += 1
        end
        arr = [right_w, left_w, top_w, down_w]
        ray = []
        arr.each {|i| i > 0 ? ray << i : next}
        if @splayer == "white"
            ray
        elsif @splayer == "black"
            ray = ray.reverse
            ray
        end
    end

    def knight_w(cols, rows)
        moves_k = []
        @knight_m.each do |m|
            if empty_tile(cols + m[0], rows + m[1])
                moves_k << m
            end
        end
        if @splayer == "white"
            moves_k
        elsif @splayer == "black"
            moves_k = moves_k.reverse
            moves_k
        end
    end

    def bishop_m(cols, rows)
        t_right = 0
        t_left = 0
        b_right = 0
        b_left = 0
        y = cols + 1
        x = rows + 1
        until !empty_tile(y, x)
            y += 1
            x += 1
            t_right += 1
        end
        y = cols + 1
        x = rows - 1
        until !empty_tile(y, x)
            y += 1
            x -= 1
            t_left += 1
        end
        y = cols - 1
        x = rows + 1
        until !empty_tile(y, x)
            y -= 1
            x += 1
            b_right += 1
        end
        y = cols - 1
        x = rows - 1
        until !empty_tile(y, x)
            y -= 1
            x -= 1
            b_left += 1
        end
        arr = [t_right, t_left, b_right, b_left]
        ray = []
        arr.each {|i| i > 0 ? ray << i : next}
        if @splayer == "white"
            ray
        elsif @splayer == "black"
            ray = ray.reverse
            ray
        end
    end

    def queen_m(cols, rows)
        diagonal = bishop_m(cols, rows)
        verhor = rook_m(cols, rows)
        ray = [[diagonal], [verhor]]
        ray
    end

    def king_m(cols, rows)
        ray = []
        if empty_tile(cols + 1, rows)
            ray << [1, 0]
        elsif empty_tile(cols + 1, rows + 1)
            ray << [1, 1]
        elsif empty_tile(cols, rows + 1)
            ray << [0, 1]
        elsif empty_tile(cols - 1, rows + 1)
            ray << [-1, 1]
        elsif empty_tile(cols - 1, rows)
            ray << [-1, 0]
        elsif empty_tile(cols - 1, rows - 1)
            ray << [-1, -1]
        elsif empty_tile(cols, rows - 1)
            ray << [0, -1]
        elsif empty_tile(cols + 1, rows - 1)
            ray << [1, -1]
        end
        if @splayer == "white"
            ray
        elsif @splayer == "black"
            ray = ray.reverse
            ray
        end
    end

end