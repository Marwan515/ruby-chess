require 'colorize'

class ChessBoard

    def initialize
        @grid = Array.new(8) {Array.new(8) {" "}}
        @white_pcs = [white_rook, white_knight, white_bishop, white_queen, white_king, white_bishop, white_knight, white_rook]
        @black_pcs = [black_rook, black_knight, black_bishop, black_queen, black_king, black_bishop, black_knight, black_rook]
        @pind = nil
        @wp = white_pawn
        @bp = black_pawn
        @abcs = {"a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7}
        @splayer = nil
        @knight_m = [[2, 1], [2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2], [-2, 1], [-2, -1]]
        @king_moved = [false, false]
        @pone_capture = []
        @ptwo_capture = []
        @stop = false
        @white_kings_threat = [black_queen, black_bishop, black_rook, black_knight]
        @black_kings_threat = [white_queen, white_bishop, white_rook, white_knight]
        make_brd
    end
    # make the board
    def make_brd
        @grid.each_with_index do |row, idx|
            row.each_with_index do |a, v|
                if idx < 1
                    row[v] = @white_pcs[v]
                elsif idx == 1
                    row[v] = @wp
                elsif idx == 6
                    row[v] = @bp
                elsif idx == 7
                    row[v] = @black_pcs[v]
                end
            end
        end
    end
    def display_board
        @grid.each_with_index do |row, idx|
            j = idx + 1
            j.to_s
            puts "#{j} " + row.join("|").colorize(:background => :black)
        end
        puts ("  A B C D E F G H")
        if @pone_capture.length > 0
            puts "Player One's Captured Pieces: #{@pone_capture}".colorize(:color => :white, :background => :red)
        end
        if @ptwo_capture.length > 0
            puts "Player two's Captured Pieces: #{@ptwo_capture}".colorize(:color => :white, :background => :blue)
        end
        if @splayer == "white"
            puts "Player ONE's TURN".colorize(:color => :white, :background => :red)
        elsif @splayer == "black"
            puts "Player TWO's TURN".colorize(:color => :white, :background => :blue)
        end
    end
    # chess piece selection
    def select_piece(player = @splayer)
        puts "Select Your Piece Enter Alphabet And Number, Example: D8 = White King 1"
        puts "Enter Your Selection: "
        x = gets.chomp.downcase
        x = x.split("")
        ro = x[1].to_i
        rows = ro - 1
        col = @abcs[x[0]]
        play_list = nil
        if player == "white"
            play_list = @white_pcs
            play_list << white_pawn
        elsif player == "black"
            play_list = @black_pcs
            play_list << black_pawn
        end
        if play_list.include?(@grid[rows][col])
            m = @grid[rows][col]
            if m == black_bishop || m == white_bishop
                h = bishop_moves(rows, col)
                if h.length < 1
                    puts "No Possible Moves For This Piece!"
                    select_piece
                end
            elsif m == black_rook || m == white_rook
                h = rook_moves(rows, col)
                if h.length < 1
                    puts "No Possible Moves For This Piece!"
                    select_piece
                end
            elsif m == black_queen || m == white_queen
                h = queen_moves(rows, col)
                if h.length < 1
                    puts "No Possible Moves For This Piece!"
                    select_piece
                end
            elsif m == black_knight || m == white_knight
                h = knight_moves(rows, col)
                if h.length < 1
                    puts "No Possible Moves For This Piece!"
                    select_piece
                end
            elsif m == black_king || m == white_king
                h = king_moves
                if h.length < 1
                    puts "No Possible Moves For This Piece!"
                    select_piece
                end
            elsif m == black_pawn || m == white_pawn
                h = pawn_moves(rows, col)
                if h.length < 1
                    puts "No Possible Moves For This Piece!"
                    select_piece
                end
            end
            @pind = [rows, col]
        else
            puts "Its Not Your PIECE!!!!!!"
            select_piece
        end
    end

    def op_player(player = @splayer)
        play_list = nil
        if player == "white"
            play_list = @black_pcs
            play_list << @bp
        elsif player == "black"
            play_list = @white_pcs
            play_list << @wp
        end
        play_list
    end

    # check tile if its empty
    def empty_tile(rows, col, st = @stop)
        op = op_player
        if @grid[rows].nil?
            false
        elsif st == true
            false
        elsif @grid[rows][col] == " "
            true
        elsif op.include?(@grid[rows][col])
            st = true
            true
        end
    end

    def player_on(player)
        @splayer = player
    end

    def white_king
        "\u2654"
    end

    def white_queen
        "\u2655"
    end

    def white_knight
        "\u2658"
    end

    def white_rook
        "\u2656"
    end

    def white_bishop
        "\u2657"
    end

    def white_pawn
        "\u2659"
    end

    def black_king
        "\u265a"
    end

    def black_queen
        "\u265b"
    end

    def black_rook
        "\u265c"
    end

    def black_bishop
        "\u265d"
    end

    def black_knight
        "\u265e"
    end

    def black_pawn
        "\u265f"
    end

    def pawn_moves(rows, col, player = @splayer)
        start_pos = nil
        if rows == 1 || rows == 6
            start_pos = true
        else
            start_pos = false
        end
        moves = []
        if start_pos == true
            if player == "white"
                @stop = false
                if empty_tile(rows + 2, col)
                    moves << [rows + 2, col]
                end
                @stop = false
                if empty_tile(rows + 1, col)
                    moves << [rows + 1, col]
                end
            elsif player == "black"
                @stop = false
                if empty_tile(rows - 2, col)
                    moves << [rows - 2, col]
                end
                @stop = false
                if empty_tile(rows - 1, col)
                    moves << [rows -1, col]
                end
            end
        else
            if player == "white"
                a = [[rows + 1, col + 1], [rows + 1, col - 1]]
                a.each do |i|
                    @stop = false
                    if empty_tile(i[0], i[1])
                        moves << i
                    end
                end
            elsif player == "black"
                a = [[rows - 1, col - 1], [rows - 1, col + 1]]
                a.each do |i|
                    @stop = false
                    if empty_tile(i[0], i[1])
                        moves << i
                    end
                end
            end
        end
        moves
    end

    def rook_moves(rows, col, player = @splayer)
        moves = []
        t = rows
        r = col
        b = rows
        l = col
        @stop = false
        while empty_tile(t + 1, col)
            t += 1
            moves << [t, col]
            @stop = false
        end
        while empty_tile(rows, r + 1)
            r += 1
            moves << [rows, r]
            @stop = false
        end
        while empty_tile(b - 1, col)
            b -= 1
            moves << [b, col]
            @stop = false
        end
        while empty_tile(rows, l - 1)
            l -= 1
            moves << [rows, l]
            @stop = false
        end
        if player == "black"
            moves.reverse
            moves
        else
            moves
        end
    end

    def bishop_moves(rows, col, player = @splayer)
        moves = []
        tb = rows
        rl = col
        @stop = false
        while empty_tile(tb + 1, rl + 1)
            tb += 1
            rl += 1
            moves << [tb, rl]
            @stop = false
        end
        tb = rows
        rl = col
        while empty_tile(tb - 1, rl + 1)
            tb -= 1
            rl += 1
            moves << [tb, rl]
            @stop = false
        end
        tb = rows
        rl = col
        while empty_tile(tb - 1, rl - 1)
            tb -= 1
            rl -= 1
            moves << [tb, rl]
            @stop = false
        end
        tb = rows
        rl = col
        while empty_tile(tb + 1, rl - 1)
            tb += 1
            rl -= 1
            moves << [tb, rl]
            @stop = false
        end
        if player == "black"
            moves.reverse
            moves
        else
            moves
        end
    end

    def knight_moves(rows, col, player = @splayer)
        moves = []
        @knight_m.each do |i|
            @stop = false
            if empty_tile(rows + i[0], col + i[1])
                moves << [rows + i[0], col + i[1]]
            end
        end
        if player == "black"
            moves.reverse
        else
            moves
        end
    end

    def queen_moves(rows, col, player = @splayer)
        moves = []
        diag = bishop_moves(rows, col)
        line = rook_moves(rows, col)
        diag.each { |i| moves << i }
        line.each { |i| moves << i }
        moves
    end

    def king_moves(player = @splayer)
        moves = []
        rows = nil
        k = nil
        if player == "white"
            k = white_king
        else
            k = black_king
        end
        @grid.each_with_index { |i, x| i.include?(k) ? rows = x : next }
        col = @grid[rows].index(k)
        @stop = false
        if empty_tile(rows + 1, col)
            moves << [rows + 1, col]
            @stop = false
        elsif empty_tile(rows + 1, col + 1)
            moves [rows + 1, col + 1]
            @stop = false
        elsif empty_tile(rows, col + 1)
            moves << [rows, col + 1]
            @stop = false
        elsif empty_tile(rows - 1, col + 1)
            moves << [rows - 1, col + 1]
            @stop = false
        elsif empty_tile(rows - 1, col)
            moves << [rows - 1, col]
            @stop = false
        elsif empty_tile(rows - 1, col - 1)
            moves << [rows - 1, col - 1]
            @stop = false
        elsif empty_tile(rows, col - 1)
            moves << [rows, col - 1]
            @stop = false
        elsif empty_tile(rows + 1, col - 1)
            moves << [rows + 1, col - 1]
            @stop = false
        end
        if player == "black"
            moves.reverse
            moves
        else
            moves
        end
    end

    def check_mate(player = @splayer)
        k = nil
        if player == "white"
            k = black_king
        elsif player == "black"
            k = white_king
        end
        won = 0
        @grid.each do |i|
            if i.include?(k)
                won = false
            end
        end
        if won == false
            false
        else
            true
        end
    end

    def pawn_promotion(player = @splayer)
        g = @grid
        promo = false
        col = nil
        rows = nil
        if g[0].include?(black_pawn)
            rows = 0
            promo = true
            col = g[rows].index(black_pawn)
        elsif g[-1].include?(white_pawn)
            promo = true
            rows = 7
            col = g[rows].index(white_pawn)
        end
        j = nil
        if promo == true
            puts "Select Your Promotion Piece\nEnter [1] To Promote To Queen\n Enter [2] To Promote To Bishop\nEnter [3] To Promote To Rook\n Enter [4] To Promote To Knight"
            j = gets.chomp
            if j == "1"
                if player == "white"
                    g[rows][col] = white_queen
                elsif player == "black"
                    g[rows][col] = black_queen
                end
            elsif j == "2"
                if player == "white"
                    g[rows][col] = white_bishop
                elsif player == "black"
                    g[rows][col] = black_bishop
                end
            elsif j == "3"
                if player == "white"
                    g[rows][col] = white_rook
                elsif player == "black"
                    g[rows][col] = black_rook
                end
            elsif j == "4"
                if player == "white"
                    g[rows][col] = white_knight
                elsif player == "black"
                    g[rows][col] = black_knight
                end
            else
                puts "Eh Eh Wrong Entry"
                pawn_promotion
            end
        end
    end

    def captured(piece, player = @splayer)
        if player == "white"
            if piece != " "
                @pone_capture << piece
            end
        elsif player == "black"
            if piece != " "
                @ptwo_capture << piece
            end
        end
    end

    def moved_piece(rowf, colf, rowt, colt)
        captured(@grid[rowt][colt])
        @grid[rowt][colt] = @grid[rowf][colf]
        @grid[rowf][colf] = " "
    end

    def move(player = @splayer)
        g = @grid
        current_col = @pind[1]
        current_row = @pind[0]
        puts "Enter The Tile To move"
        j = gets.chomp.split("")
        col = @abcs[j[0]]
        rows = j[1].to_i
        rows -= 1
        yes = false
        moveable = nil
        if g[current_row][current_col] == white_pawn || g[current_row][current_col] == black_pawn
            moveable = pawn_moves(current_row, current_col)
            puts moveable
            moveable.each do |i|
                if i[0] == rows && i[1] == col
                    yes = true
                end
            end
            if yes == false
                puts "Not Moveable Tile Error"
                move
            else
                moved_piece(current_row, current_col, rows, col)
                pawn_promotion
            end
        elsif g[current_row][current_col] == white_knight || g[current_row][current_col] == black_knight
            moveable = knight_moves(current_row, current_col)
            moveable.each do |i|
                if i[0] == rows && i[1] == col
                    yes = true
                end
            end
            if yes == false
                puts "Not Moveable Tile Error"
                move
            else
                moved_piece(current_row, current_col, rows, col)
            end
        elsif g[current_row][current_col] == white_queen || g[current_row][current_col] == black_queen
            moveable = queen_moves(current_row, current_col)
            moveable.each do |i|
                if i[0] == rows && i[1] == col
                    yes = true
                end
            end
            if yes == false
                puts "Not Moveable Tile Error"
                move
            else
                moved_piece(current_row, current_col, rows, col)
            end
        elsif g[current_row][current_col] == white_bishop || g[current_row][current_col] == black_bishop
            moveable = bishop_moves(current_row, current_col)
            moveable.each do |i|
                if i[0] == rows && i[1] == col
                    yes = true
                end
            end
            if yes == false
                puts "Not Moveable Tile Error"
                move
            else
                moved_piece(current_row, current_col, rows, col)
            end
        elsif g[current_row][current_col] == white_rook || g[current_row][current_col] == black_rook
            moveable = rook_moves(current_row, current_col)
            moveable.each do |i|
                if i[0] == rows && i[1] == col
                    yes = true
                end
            end
            if yes == false
                puts "Not Moveable Tile Error"
                move
            else
                moved_piece(current_row, current_col, rows, col)
            end
        elsif g[current_row][current_col] == white_king || g[current_row][current_col] == black_king
            moveable = king_moves
            moveable.each do |i|
                if i[0] == rows && i[1] == col
                    yes = true
                end
            end
            if yes == false
                puts "Not Moveable Tile Error"
                move
            else
                moved_piece(current_row, current_col, rows, col)
            end
        end
    end

end
