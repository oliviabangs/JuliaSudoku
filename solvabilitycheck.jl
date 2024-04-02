function generate_solve_board(board::Array{UInt, 2})::Array{UInt, 2}
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
    num_touch += 1
end

function fill_cell(board::Array{UInt, 2}, value::UInt, pos::Tuple{UInt, UInt})::UInt
end

function move_backwards(pos::Tuple{UInt, UInt}, number_of_times::UInt)::Tuple{UInt, UInt}
    if pos == (0, 0)
        return (0, 0)
    end

    new_row, new_col = pos 

    for _ in 1:number_of_times
        if new_col == 1
            new_col = 8
            new_row -= 1
        else
            new_col -= 1
        end
    end
    return (new_row, new_col)
end

function move_forwards(os::Tuple{UInt, UInt}, number_of_times::UInt)::Tuple{UInt, UInt}
end