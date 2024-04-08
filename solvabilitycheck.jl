include("utilities.jl")

function generate_solve_board(board::Array{Int, 2})::Array{Int, 2}
    # Creates a list of the location of the hints
    hints::Vector{Tuple{Int, Int}} = []

    # Loops through rows
    for i in 1:size(board, 1)     
        # Loops through columns
        for j in 1:size(board, 2) 
            if board[i, j] != 0
                push!(hints, (i, j))
            end
        end
    end
    return solving_recursive_helper(board, (0,0), hints, false, 0)
end

function solving_recursive_helper(board::Array{Int, 2}, pos::Tuple{Int, Int}, hints::Vector{Tuple{Int, Int}}, backtracking::Bool, num_touch::Int)::Array{Int, 2}
    # Keeping track of how many times the recusion happens to catch infinite insolvability loops before they happen
    num_touch += 1

    # Stops once every spot has a value or it appears to be unsolvable
    if every_spot_full(board) || num_touch > 10000
        println(num_touch)
        printboard(board)
        return board
    # Handles when the position is not a hint
    elseif !(pos in hints)
        # Increments the value already at that location
        value::Int = board[pos[1], pos[2]] + 1

        # Checks whether that value or another is possible
        current_value::Int = fill_cell(board, value, pos)

        # Indicates that backtracking is needed
        if current_value == 100
            # Negates what was at that position and moves backwared
            board[pos[1], pos[2]] = 0
            return solving_recursive_helper(board, move_backwards(pos, 1), hints, true, num_touch)

        # Backtracking not needed
        else
            # Value update and position moves forward
            board[pos[1], pos[2]] = current_value
            return solving_recursive_helper(board, move_forwards(pos, 1), hints, false, num_touch)
        end
    # Handles if the position is a hint since it can't change the hint
    else
        # Moves back past the hint if its in backtracking mode
        if backtracking
            return solving_recursive_helper(board, move_backwards(pos, 1), hints, true, num_touch)
         # Moves forward past the hint
        else
            return solving_recursive_helper(board, move_forwards(pos, 1), hints, false, num_touch)
        end
    end
end

function fill_cell(board::Array{Int, 2}, value::Int, pos::Tuple{Int, Int})::Int
    if value > 9
        return 100
    end

    validity = validacrossboard(board, value, pos)
    if validity 
        return value
    else
        if value == 9
            return 100
        else
            return fill_cell(board, value + 1, pos)
        end
    end
end

function move_backwards(pos::Tuple{Int, Int}, number_of_times::Int)::Tuple{Int, Int}
    # First digit in tuple is row
    if pos == (1, 1)
        return (1, 1)
    end

    new_row, new_col = pos 

    for _ in 1:number_of_times
        if new_col == 1
            new_col = 9
            new_row -= 1
        else
            new_col -= 1
        end
    end
    return (new_row, new_col)
end

function move_forwards(pos::Tuple{Int, Int}, number_of_times::Int)::Tuple{Int, Int}
    if pos == (9, 9)
        return (9, 9)
    end

    new_row, new_col = pos 

    for _ in 1:number_of_times
        if new_col + 1 > 9
            new_col = 1
            new_row += 1
        else
            new_col += 1
        end
    end
    return (new_row, new_col)
end

#Some informal testing
function solvabilitytests()
    #Creating a board and inserting values into it (putting the box's number in its bottom right cell)
    testingboard = fill(0, 9, 9)
    testingboard[3, 3] = 1
    testingboard[3, 6] = 2
    testingboard[3, 9] = 3
    testingboard[6, 3] = 4
    testingboard[6, 6] = 5
    testingboard[6, 9] = 6
    testingboard[9, 3] = 7
    testingboard[9, 6] = 8
    testingboard[9, 9] = 9

    # Board filled with values of 1
    testingboard2 = fill(1, 9, 9)

    # Board w/ only valid hiints
    testingboard3 = fill(0, 9, 9)
    testingboard3[1,2] = 4
    testingboard3[1,5] = 6
    testingboard3[1,7] = 9
    testingboard3[3,2] = 7
    testingboard3[3,3] = 8
    testingboard3[3,6] = 1
    testingboard3[3,9] = 4
    testingboard3[4,2] = 6
    testingboard3[4,6] = 4
    testingboard3[4,7] = 1
    testingboard3[5,3] = 5
    testingboard3[5,4] = 9
    testingboard3[6,7] = 5
    testingboard3[7,1] = 2
    testingboard3[7,5] = 3
    testingboard3[8,7] = 3
    testingboard3[8,9] = 8
    testingboard3[9,1] = 7
    testingboard3[9,5] = 2
    hints::Vector{Tuple{Int, Int}} = [(1,2),(1,5),(1,7),(3,2),(3,3),(3,6),(3,9),(4,2),(4,6),
                                      (4,7),(5,3),(5,4),(6,7),(7,1),(7,5),(8,7),(8,9),
                                      (9,1),(9,5)
                                     ]
    
    # False tests
    # println(check_spot_occupied(3, 3, testingboard)) # Should be false (spot occupied)
    # println(every_spot_full(testingboard)) # Should be false (not every spot is not empty)
    
    # True tests
    # println(check_spot_occupied(3, 2, testingboard)) # Should be true (spot not occupied)
    # println(every_spot_full(testingboard2)) # Should be true (every cell is not empty)

    printboard(testingboard3)
    solving_recursive_helper(testingboard3, (1,1), hints, false, 0)
    #println(fill_cell(testingboard3,1,(1,1)))

    # println(move_backwards((9,9), 2)) # Should be (9,7)
    # println(move_backwards((9,1), 1)) # Should be (8,9)
    # println(move_backwards((1,1), 2)) # Should be (1,1)

    # println(move_forwards((9,9), 1)) # Should be (9,9)
    # println(move_forwards((8,9), 1)) # Should be (9,1)
    # println(move_forwards((9,7), 2)) # Should be (9,9)
    
end