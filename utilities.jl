include("solvabilitycheck.jl")

function check_spot_occupied(row::Int, col::Int, board_state::Array{Int, 2})::Bool
    return board_state[row, col] == 0
end

function every_spot_full(board::Array{Int, 2})::Bool
    for i in 1:length(board)
        for j in 1:length(board[1])
            if board[i, j] == 0
                return false
            end
        end
    end
    return true
end
