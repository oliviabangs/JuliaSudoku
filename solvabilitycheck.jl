function generate_solve_board(board::Array{UInt, 2})::Array{UInt, 2}
    # Creates a list of the location of the hints
    hints::Vector{Tuple{UInt, UInt}} = []

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

function solving_recursive_helper(board::Array{UInt, 2}, pos::Tuple{UInt, UInt}, hints::Vector{Tuple{UInt, UInt}}, backtracking::Bool, num_touch::UInt)::Array{UInt, 2}
    # Keeping track of how many times the recusion happens to catch infinite insolvability loops before they happen
    num_touch += 1

    # Stops once every spot has a value or it appears to be unsolvable
    if every_spot_full(board) || num_touch > 1000 
        return board
    # Handles when the position is not a hint
    elseif !(pos in hints)
        # Increments the value already at that location
        value::UInt = board[pos[1], pos[2]] + 1

        # Checks whether that value or another is possible
        current_value::UInt = fill_cell(board, value, pos)

        # Indicates that backtracking is needed
        if current_value == 100
            # Negates what was at that position and moves backwared
            board[pos[1], pos[2]] = 0
            return solving_recursive_helper(board, move_backwards(pos, 1), hints, true, num_touch)

        # Backtracking not needed
        else
            # Value update and position moves forward
            board[pos[1], pos[2]] = current_value
            return solving_recursive_helper(board, move_fowards(pos, 1), hints, false, num_touch)
        end
    # Handles if the position is a hint since it can't change the hint
    else
        # Moves back past the hint if its in backtracking mode
        if backtracking
            return solving_recursive_helper(board, move_backwards(pos, 1), hints, true, num_touch)
         # Moves forward past the hint
        else
            return solving_recursive_helper(board, move_backwards(pos, 1), hints, false, num_touch)
        end
    end
end

function fill_cell(board::Array{UInt, 2}, value::UInt, pos::Tuple{UInt, UInt})::UInt
    if value > 9
        return 100
    end

    validity = valid(board, value, pos)
    if validity 
        return value
    else
        return fill_cell(board, value + 1, pos)
    end
end

function move_backwards(pos::Tuple{UInt, UInt}, number_of_times::UInt)::Tuple{UInt, UInt}
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

function move_forwards(pos::Tuple{UInt, UInt}, number_of_times::UInt)::Tuple{UInt, UInt}
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