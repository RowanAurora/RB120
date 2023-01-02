# def draw 
#   puts "     |     |"
#   puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
#   puts "     |     |"
#   puts "-----+-----+-----"
#   puts "     |     |"
#   puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
#   puts "     |     |"
#   puts "-----+-----+-----"
#   puts "     |     |"
#   puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
#   puts "     |     |"
# end

@squares = ['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x']

board_arr = ["     |     |",
"  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}", "     |     |",
"-----+-----+-----", "     |     |", "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}",
"     |     |", "-----+-----+-----", "     |     |", "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}",
"     |     |" ]

board_arr.each { |line| puts line }