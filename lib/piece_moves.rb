module ChessMoves
    include ChessBoard
    include Pieces

    def initialize
        @splayer = nil
        @knight_m = [[2, 1], [2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2], [-2, 1], [-2, -1]]
        @king_moved = [false, false]
        @white_kings_threat = [black_queen, black_bishop, black_knight, black_rook]
        @black_kings_threat = [white_queen, white_bishop, white_knight, white_rook]
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
    # knights possible moves
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
    # bishops possible moves
    def bishop_m(cols, rows, player = @splayer)
        t_right = [0, 0]
        t_left = [0, 0]
        b_right = [0, 0]
        b_left = [0, 0]
        y = cols + 1
        x = rows + 1
        until !empty_tile(y, x)
            y += 1
            x += 1
            t_right[0] += 1
            t_right[1] += 1
        end
        y = cols + 1
        x = rows - 1
        until !empty_tile(y, x)
            y += 1
            x -= 1
            t_left[0] += 1
            t_left[1] -= 1
        end
        y = cols - 1
        x = rows + 1
        until !empty_tile(y, x)
            y -= 1
            x += 1
            b_right[0] -= 1
            b_right[1] += 1
        end
        y = cols - 1
        x = rows - 1
        until !empty_tile(y, x)
            y -= 1
            x -= 1
            b_left[0] -= 1
            b_left[0] -= 1
        end
        arr = [t_right, t_left, b_right, b_left]
        ray = []
        arr.each {|i| i > 0 ? ray << i : next}
        if player == "white"
            ray
        elsif player == "black"
            ray = ray.reverse
            ray
        end
    end
    # queens possible moves
    def queen_m(cols, rows)
        diagonal = bishop_m(cols, rows)
        verhor = rook_m(cols, rows)
        ray = [[diagonal], [verhor]]
        ray
    end
    # kings possible moves
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
    # pawn promotion
    def pawn_promotion
        pawn_promo = nil
        y = nil
        wpp = nil
        if @splayer == "white"
            y = -1
            pawn_promo = white_pawn
            wpp = [white_queen, white_rook, white_bishop, white_knight]
        elsif @splayer == "black"
            y = 7
            pawn_promo = black_pawn
            wpp = [black_queen, black_rook, black_bishop, black_knight]
        end
        if @grid[y].include?(pawn_promo)
            x = @grid[y].index(pawn_promo)
            puts "Select Promotion\n[#{wpp[0]}] Queen Enter => [1]: \n[#{wpp[1]}] Rook Enter => [2]: \n[#{wpp[2]}] Bishop Enter => [3]: \n[#{wpp[3]}] knight Enter => [4]: "
            a = gets.chomp
            if a == "1"
                @grid[y][x] = wpp[0]
            elsif a == "2"
                @grid[y][x] = wpp[1]
            elsif a == "3"
                @grid[y][x] = wpp[2]
            elsif a == "4"
                @grid[y][x] = wpp[3]
            else
                pawn_promotion
            end
        end
    end

    def check_check
        my_checked = nil
        op_king = nil
        my_king = nil
        kings_row = nil
        king_col = nil
        op_kings_row = nil
        op_kings_col = nil
        if @splayer == "white"
            my_king = white_king
            op_king = black_king
        elsif @splayer == "black"
            my_king = black_king
            op_king = white_king
        end
        @grid.each_with_index do |i, n|
            if i.include?(my_king)
                king_col = n
            elsif i.include?(op_king)
                op_kings_col = n
            end
        end
        kings_row = @grid[king_col].index(my_king)
        op_kings_row = @grid[op_kings_col].index(op_king)
        my_diag = bishop_m(king_col, kings_row)
        my_horiver = rook_m(king_col, kings_row)
        my_diag.each_with_index do |i, n|
            if n < 1
                i[0] += 1
                i[1] += 1
                t = @grid[i[0]][i[1]]
                if @splayer == "white" && @black_pcs.include?(t) && @white_kings_threat.include?(t)
                    if t == black_queen || t == black_bishop
                        my_checked = true
                    elsif t == black_pawn && i[0] < 2
                        my_checked = true
                    end
                end
            end
        end



    end

    def castling(cols, rows)
        cking = nil
        krow = nil
        if @splayer == "white"
            cking = white_king
            krow = @grid[0].index(cking)
        elsif @splayer == "black"
            cking = black_king
            krow = @grid[7].index(cking)
        end

    end

end