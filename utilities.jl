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

# Some informal testing
# function validtests()
#     Creating a board and inserting values into it (putting the box's number in its bottom right cell)
#     testingboard = fill(0, 9, 9)
#     testingboard[3, 3] = 1
#     testingboard[3, 6] = 2
#     testingboard[3, 9] = 3
#     testingboard[6, 3] = 4
#     testingboard[6, 6] = 5
#     testingboard[6, 9] = 6
#     testingboard[9, 3] = 7
#     testingboard[9, 6] = 8
#     testingboard[9, 9] = 9
    
#     #Tests
#     println(check_spot_occupied(3, 3, testingboard)) #should be false
#     println(every_spot_full(testingboard)) #should be false

#    #println(generate_solve_board(testingboard)) 
#    println(fill_cell(testingboard,9,))
#    println(move_backwards((3,3), 1)) # (3, 2)
#    println(move_backwards((3,1), 1)) # (2, 9)
#    println(move_backwards((1,1), 1)) # (1, 1)
#    println(move_forwards((3,3), 1)) # (3, 4)
#    println(move_forwards((3,9), 1)) # (4, 1)
#    println(move_forwards((9,9), 1)) # (9, 9)

# end