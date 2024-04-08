#include("solvabilitycheck.jl")

function check_spot_occupied(row::Int, col::Int, board_state::Array{Int, 2})::Bool
    return board_state[row, col] == 0
end

function every_spot_full(board::Array{Int, 2})::Bool
    for i in 1:9
        for j in 1:9
            if board[i, j] == 0
                return false
            end
        end
    end
    return true
end

#Basic testing function that displays the board
function printboard(board) 
    println(" -----------------------------")
    for row in 1:9
        print("|")
        for col in 1:9
            if col % 3 == 0 && col != 9 
                print(" ", board[row, col], " |")
            else
                print(" ", board[row, col], " ")
            end
        end
        print("|")
        println("")
        if row % 3 == 0 
            println(" -----------------------------")
        end 
    end
end

#Checks overall validity based on the row, column, and box
function validacrossboard(board, value, position)
    if validincolumn(board, value, position) && validinrow(board, value, position) && validinbox(board, value, position)
        return true
    else
        return false
    end
end 

#Checks validity in column
function validincolumn(board, value, position)
    col = board[:, position[2]]
    for cell in col
        if cell == value
            return false
        end
    end
    return true
end

#Checks validity in row
function validinrow(board, value, position)
    row = board[position[1], :]
    for cell in row
        if cell == value
            return false
        end
    end
    return true
end

#Checks validity in box
function validinbox(board, value, position)
    currentbox = determinebox(position)
    box = getboxslice(currentbox, board)
    for cell in box
        if cell == value
            return false
        end
    end
    return true
end

#Uses ranges to determine what box the position is in
function determinebox(position)
    #Fist row of boxes
    if position[1] > 0 && position[1] < 4
        #First column of boxes
        if position[2] > 0 && position[2] < 4
            return 1
        #Middle column of boxes
        elseif position[2] > 4 && position[2] < 7
            return 2
        #Last column of boxes
        else
            return 3
        end
    #Middle row of boxes
    elseif position[1] > 4 && position[1] < 7
        if position[2] > 0 && position[2] < 4
            return 4
        elseif position[2] > 4 && position[2] < 7
            return 5
        else
            return 6
        end
    #Bottom row of boxes
    else
        if position[2] > 0 && position[2] < 4
            return 7
        elseif position[2] > 4 && position[2] < 7
            return 8
        else
            return 9
        end
    end
end

#Returns a view into a box of the board based on the given box number
function getboxslice(box, board)
    coords = Dict(
        1 => board[1:3, 1:3], 
        2 => board[1:3, 4:6], 
        3 => board[1:3, 7:9], 
        4 => board[4:6, 1:3], 
        5 => board[4:6, 4:6],
        6 => board[4:6, 7:9], 
        7 => board[7:9, 1:3], 
        8 => board[7:9, 4:6], 
        9 => board[7:9, 7:9])

    return coords[box]
end

#Some informal testing
function utilitiestests()
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
    
    # False tests
    # println(validacrossboard(testingboard, 1, (7,3))) #should be false (col conflict)
    # println(validacrossboard(testingboard, 4, (6,4))) #should be false (row conflict)
    # println(validacrossboard(testingboard, 3, (2,8))) #should be false (box conflict)
    
    # True tests
    # println(validacrossboard(testingboard, 5, (8,1))) #should be true
    # println(validacrossboard(testingboard, 8, (7,1))) #should be true
    
end
