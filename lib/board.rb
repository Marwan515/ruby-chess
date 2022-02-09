require 'colorize'

class ChessBoard

    def initialize
        @grid = Array.new(8) {Array.new(8) {" "}}
    end

    def make_board(brd = @grid)
        brd.each do |i|
            i.each_with_index do |a, n|
                
            end
        end
        puts brd
    end

end
x = ChessBoard.new
x.make_board