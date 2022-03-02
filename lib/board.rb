require 'colorize'
require 'yaml'

class ChessBoard

    def initialize
        @game_ended = false
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
        start
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
        puts "Select Your Piece Enter Alphabet And Number, Example: D8 = White King 1 Or Enter: [s] To Save The Game"
        puts "Enter Your Selection: "
        x = gets.chomp.downcase
        if x == "s"
            save
        else
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
        if @grid[rows].nil? || @grid[rows][col].nil?
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

    def en_game(ended = @game_ended)
        ended
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
    # get all the legal move pawn
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
    # get all the legal move rook
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
        end
        @stop = false
        while empty_tile(rows, r + 1)
            r += 1
            moves << [rows, r]
        end
        @stop = false
        while empty_tile(b - 1, col)
            b -= 1
            moves << [b, col]
        end
        @stop = false
        while empty_tile(rows, l - 1)
            l -= 1
            moves << [rows, l]
        end
        @stop = false
        if player == "black"
            moves.reverse
            moves
        else
            moves
        end
    end
    # get all the legal move bishop
    def bishop_moves(rows, col, player = @splayer)
        moves = []
        tb = rows
        rl = col
        @stop = false
        while empty_tile(tb + 1, rl + 1)
            tb += 1
            rl += 1
            moves << [tb, rl]
        end
        tb = rows
        rl = col
        @stop = false
        while empty_tile(tb - 1, rl + 1)
            tb -= 1
            rl += 1
            moves << [tb, rl]
        end
        tb = rows
        rl = col
        @stop = false
        while empty_tile(tb - 1, rl - 1)
            tb -= 1
            rl -= 1
            moves << [tb, rl]
        end
        tb = rows
        rl = col
        @stop = false
        while empty_tile(tb + 1, rl - 1)
            tb += 1
            rl -= 1
            moves << [tb, rl]
        end
        @stop = false
        if player == "black"
            moves.reverse
            moves
        else
            moves
        end
    end
    # get all the legal move knight
    def knight_moves(rows, col, player = @splayer)
        moves = []
        @knight_m.each do |i|
            @stop = false
            if empty_tile(rows + i[0], col + i[1])
                moves << [rows + i[0], col + i[1]]
            end
        end
        @stop = false
        if player == "black"
            moves.reverse
        else
            moves
        end
    end
    # get all the legal move queen
    def queen_moves(rows, col, player = @splayer)
        moves = []
        diag = bishop_moves(rows, col)
        line = rook_moves(rows, col)
        diag.each { |i| moves << i }
        line.each { |i| moves << i }
        moves
    end
    # get all the legal move of king
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
        move_w = [[rows + 1, col], [rows + 1, col + 1], [rows, col + 1], [rows + 1, col - 1], [rows, col - 1]]
        move_b = [[rows - 1, col], [rows - 1, col - 1], [rows, col - 1], [rows - 1, col + 1], [rows, col + 1]]
        ex_move_w = [[rows - 1, col + 1], [rows - 1, col], [rows - 1, col - 1]]
        ex_move_b = [[rows + 1, col], [rows + 1, col + 1], [rows + 1, col - 1]]
        
        if rows > 0 && player == "white"
            ex_move_w.each {|i| move_w << i}
        elsif rows < 7 && player == "black"
            ex_move_b.each {|i| move_b << i}
        end

        if player == "white"
            move_w.each do |i|
                @stop = false
                if empty_tile(i[0], i[1])
                    moves << i
                end
            end
        end
        @stop = false
        moves
    end

    def check(player = @splayer)
        checked = []
        bis = nil
        queen = nil
        kni = nil
        rook = nil
        k = nil
        krow = nil
        if player == "white"
            k = white_king
            bis = black_bishop
            queen = black_queen
            kni = black_knight
            rook = black_rook
        elsif player == "black"
            k = black_king
            bis = white_bishop
            queen = white_queen
            kni = white_knight
            rook = white_rook
        end
        @grid.each_with_index do |i, v|
            if i.include?(k)
                krow = v
            end
        end
        kcol = nil
        @grid[krow].each_with_index {|i, x| i == k ? kcol = x : next}
        diag = bishop_moves(krow, kcol)
        diag.each do |i|
            if @grid[i[0]][i[1]] == queen || @grid[i[0]][i[1]] == bis
                checked << i
            elsif @grid[i[0]][i[1]] == kni
                if krow == i[0] - 2 || krow == i[0] + 2
                    if kcol == i[1] - 1  || kcol == i[1] + 1
                        checked << i
                    end
                elsif krow == i[0] - 1 || krow == i[0] + 1
                    if kcol == i[1] + 2 || kcol == i[1] - 2
                        checked << i
                    end
                end
            end
        end
        lined = rook_moves(krow, kcol)
        lined.each do |i|
            if @grid[i[0]][i[1]] == rook || @grid[i[0]][i[1]] == queen
                checked << i
            end
        end
        checked
    end

    def checked(player = @splayer)
        not_mated = []
        arr = check
        k = nil
        if player == "white"
            k = white_king
        else
            k = black_king
        end
        krow = nil
        @grid.each_with_index {|i, x| i.include?(k) ? krow = x : next}
        kcol = nil
        @grid.each_with_index {|i, x| i == k ? kcol = x : next}
        k_move = king_moves
        return false if arr.length < 1
        if k_move.length < 1 && arr.length > 0
            return check_mate
        elsif k_move.length < 1
            return chkmsg
        end

        if arr.length > 0 && k_move.length > 0
            k_move.each do |i|
                puts i
                pie = @grid[i[0]][i[1]]
                break if i[0].nil?
                moved_piece(krow, kcol, i[0], i[1])
                new_arr = check
                if new_arr.length > 0
                    moved_piece(i[0], i[1], krow, kcol)
                    @grid[i[0]][i[1]] = pie
                else
                    not_mated << i
                    moved_piece(i[0], i[1], krow, kcol)
                    @grid[i[0]][i[1]] = pie
                end
            end
        end

        if arr.length > 0
            if not_mated.length < 1
                check_mate
            else
                chkmsg
            end
        else
            false
        end
    end

    def chkmsg(player = @splayer)
        a = "PLAYER ONE".colorize(:color => :white, :background => :red)
        b = "PLAYER TWO".colorize(:color => :white, :background => :blue)
        if player == "white"
            puts "#{a} CHECKED! #{b}"
        else
            puts "#{b} CHECKED! #{a}"
        end 
    end

    def check_mate
        pone = "PLAYER ONE".colorize(:color => :white, :background => :red)
        ptwo = "PLAYER TWO".colorize(:color => :white, :background => :blue)
        if @splayer == "white"
            puts "#{pone} Check Mated #{ptwo}"
        elsif @splayer == "black"
            puts "#{ptwo} Check Mated #{pone}"
        end
        true
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
            moveable.each do |i|
                if i[0] == rows && i[1] == col
                    yes = true
                end
            end
            if yes == false
                puts "Not Moveable Tile Error"
                move
            else
                captured(@grid[rows][col])
                moved_piece(current_row, current_col, rows, col)
                pawn_promotion
                a = checked
                if a == true
                    game_ended = true
                end
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
                captured(@grid[rows][col])
                moved_piece(current_row, current_col, rows, col)
                a = checked
                if a == true
                    game_ended = true
                end
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
                captured(@grid[rows][col])
                moved_piece(current_row, current_col, rows, col)
                a = checked
                if a == true
                    game_ended = true
                end
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
                captured(@grid[rows][col])
                moved_piece(current_row, current_col, rows, col)
                a = checked
                if a == true
                    game_ended = true
                end
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
                captured(@grid[rows][col])
                moved_piece(current_row, current_col, rows, col)
                a = checked
                if a == true
                    game_ended = true
                end
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
                captured(@grid[rows][col])
                moved_piece(current_row, current_col, rows, col)
                a = checked
                if a == true
                    game_ended = true
                end
            end
        end
    end

    def save
        puts "Enter Name Save To Save Your Current Progress"
        save_id = gets.chomp
        filename = "savedg/saved-#{save_id}.txt"
        player = @splayer
        arr = [player, @grid]
        File.open(filename, "w") do |fie|
            fie.write(arr.to_yaml)
        end
        @game_ended = true
    end

    def load
        j = Dir["./savedg/*"]
        puts "Enter Just The Id That's After save-:"
        j.each {|i| puts i }
        puts "Delete Load Game Enter: [d]\nEnter: [m] To Go Back To Main Menu!"
        a = gets.chomp
        if a == "d"
            del_load_game
        elsif a == "m"
            initialize
        else
            id = YAML.load(File.read("./savedg/saved-#{a}.txt"))
            @grid = id[1]
            @splayer = id[0].to_s
            @game_ended = false
        end
    end

    def start
        puts "START GAME Enter: [1]\nLOAD GAME Enter: [2]"
        a = gets.chomp
        if a == "1"
            make_brd
        elsif a == "2"
            load
        else
            start
        end
    end

    def ply(player = @splayer)
        return @splayer
    end

    def del_load_game
        j = Dir["./savedg/*"]
        puts "Enter Just The Id That's After save-:, To Delete The Loaded Game\nOr Enter: [m] To Go Back To Main Menu!"
        j.each {|i| puts i }
        a = gets.chomp
        if a == "m"
            initialize
        else
            File.delete("./savedg/saved-#{a}.txt") if File.exist?("./savedg/saved-#{a}.txt")
            initialize
        end
    end
end
