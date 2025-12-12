# We have a two-d board game involving snakes.
# The board has two types of squares on it: +'s represent impassable squares where snakes cannot go,
# and 0's represent squares through which snakes can move.
# Snakes can only enter on the edges of the board, and each snake can move in only one direction.
# We'd like to find the places where a snake can pass through the entire board, moving in a straight line.

# Here is an example board:

#     col-->        0  1  2  3  4  5  6
#                +----------------------
#     row      0 |  +  +  +  0  +  0  0
#      |       1 |  0  0  0  0  0  0  0
#      |       2 |  0  0  +  0  0  0  0
#      v       3 |  0  0  0  0  +  0  0
#              4 |  +  +  +  0  0  0  +

# Write a function that takes a rectangular board with only +'s and 0's, and returns two collections:

# * one containing all of the row numbers whose row is completely passable by snakes, and
# * the other containing all of the column numbers where the column is completely passable by snakes.

# Complexity Analysis:

# r: number of rows in the board
# c: number of columns in the board

# straight_board_1 = [['+', '+', '+', '0', '+', '0', '0'],
#                     ['0', '0', '0', '0', '0', '0', '0'],
#                     ['0', '0', '+', '0', '0', '0', '0'],
#                     ['0', '0', '0', '0', '+', '0', '0'],
#                     ['+', '+', '+', '0', '0', '0', '+']]

# find_passable_lanes(straight_board_1) # = Rows: [1], Columns: [3, 5]

# straight_board_2 = [['+', '+', '+', '0', '+', '0', '0'],
#                     ['0', '0', '0', '0', '0', '+', '0'],
#                     ['0', '0', '+', '0', '0', '0', '0'],
#                     ['0', '0', '0', '0', '+', '0', '0'],
#                     ['+', '+', '+', '0', '0', '0', '+']]

# find_passable_lanes(straight_board_2) # = Rows: [], Columns: [3]

# straight_board_3 = [['+', '+', '+', '0', '+', '0', '0'],
#                     ['0', '0', '0', '0', '0', '0', '0'],
#                     ['0', '0', '+', '+', '0', '+', '0'],
#                     ['0', '0', '0', '0', '+', '0', '0'],
#                     ['+', '+', '+', '0', '0', '0', '+']]

# find_passable_lanes(straight_board_3) # = Rows: [1], Columns: []

# straight_board_4 = [['+']]

# find_passable_lanes(straight_board_4) # = Rows: [], Columns: []

straight_board_1 = [['+', '+', '+', '0', '+', '0', '0'],
                    ['0', '0', '0', '0', '0', '0', '0'],
                    ['0', '0', '+', '0', '0', '0', '0'],
                    ['0', '0', '0', '0', '+', '0', '0'],
                    ['+', '+', '+', '0', '0', '0', '+']]

straight_board_2 = [['+', '+', '+', '0', '+', '0', '0'],
                    ['0', '0', '0', '0', '0', '+', '0'],
                    ['0', '0', '+', '0', '0', '0', '0'],
                    ['0', '0', '0', '0', '+', '0', '0'],
                    ['+', '+', '+', '0', '0', '0', '+']]

straight_board_3 = [['+', '+', '+', '0', '+', '0', '0'],
                    ['0', '0', '0', '0', '0', '0', '0'],
                    ['0', '0', '+', '+', '0', '+', '0'],
                    ['0', '0', '0', '0', '+', '0', '0'],
                    ['+', '+', '+', '0', '0', '0', '+']]

straight_board_4 = [['+']]

def solution(board):
    Row = []
    Column = []

    index = 0
    for row in board:
        index = index + 1
        found = False
        if '+' in row:
            found = True
        if found == False:
            Row.append(index-1)        # board.index(row) not used bcoz will fail for multiple similar elements

    print("ROWS ", Row)

    columns_ele = zip(*board)
    column_tuples = tuple(columns_ele)
    index = 0
    for col in column_tuples:
        index = index + 1
        found = False
        if '+' in col:
            found = True
        if found == False:
            Column.append(index-1)

    print("COLUMNS ",Column)

solution(straight_board_4)