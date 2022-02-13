module Pieces

    def pc_arr(x)
        arr = []
        if x == "white"
            arr << white_rook
            arr << white_knight
            arr << white_bishop
            arr << white_queen
            arr << white_king
            arr << white_bishop
            arr << white_knight
            arr << white_rook
        else
            arr << black_rook
            arr << black_knight
            arr << black_bishop
            arr << black_queen
            arr << black_king
            arr << black_bishop
            arr << black_knight
            arr << black_rook
        end
        arr
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
end