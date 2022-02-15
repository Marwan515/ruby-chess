require 'colorize'
require_relative 'chess_pcs.rb'

module ChessBoard
    include ChessMoves
    include Pieces

    def initialize
        @grid = Array.new(8) {Array.new(8) {" "}}
        @white_pcs = pc_arr("white")
        @black_pcs = pc_arr("black")
        @wp = white_pawn
        @bp = black_pawn
        @pind = nil
        @abcs = {"a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7}
    end
    # make the board
    def display_board
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
            j = idx + 1
            j.to_s
            puts "#{j} " + row.join(" ").colorize(:background => :black)
        end
        puts ("  A B C D E F G H")
    end
    # chess piece selection
    def select_piece
        sl = {"a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7}
        puts "Select Your Piece Enter Alphabet And Number, Example: D8 = White King 1"
        puts "Enter Your Selection: "
        x = gets.chomp.downcase
        x = x.split("")
        col = x[1].to_i - 1
        row = sl[x[0]]
        o = [col, row]
        @pind = o
        o
    end
    # check i-f the position is moveable
    def opponent(player, idx)
        a = @white_pcs
        b = @black_pcs
        if a.include?(idx) && player == "black"
            true
        elsif b.include?(idx) && player == "white"
            true
        elsif a.include?(idx) && player == "white"
            false
        elsif b.include?(idx) && player == "black"
            false
        else
            true
        end
    end
    # move the piece
    def change_place(col, row, pc)
        @grid[col][row] = pc
        @grid[pind[0]][pind[1]] = " "
    end

    def empty_tile(cols, rows)
        if !@grid[cols][rows] == " "
            true
        end
        false
    end

end
x = ChessBoard.new
x.display_board
puts x.black_pawn