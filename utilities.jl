
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
function printboard(board::Array{Int, 2}) 
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

function combinedrowcolboxslice(board::Array{Int, 2}, position::Tuple{Int, Int})
    combined = []
    col = board[:, position[2]]
    row = board[position[1], :]
    currentbox = determinebox(position)
    box = getboxslice(currentbox, board)

    append!(combined, col, row, box)
    return combined
end

#Checks overall validity based on the row, column, and box
function validacrossboard(board::Array{Int, 2}, value::Int, sliceposition::Tuple{Int, Int})::Bool
    for elem in combinedrowcolboxslice(board, sliceposition)
        if elem == value 
            return false
        end
    end
    return true
end 

#Checks validity in column
function validincolumn(board::Array{Int, 2}, value::Int, position::Tuple{Int, Int})::Bool
    col = board[:, position[2]]
    for cell in col
        if cell == value
            #println("Column violation")
            return false
        end
    end
    return true
end

#Checks validity in row
function validinrow(board::Array{Int, 2}, value::Int, position::Tuple{Int, Int})::Bool
    row = board[position[1], :]
    for cell in row
        if cell == value
            #println("Row violation")
            return false
        end
    end
    return true
end

#Checks validity in box
function validinbox(board::Array{Int, 2}, value::Int, position::Tuple{Int, Int})::Bool
    currentbox::Int = determinebox(position)
    box = getboxslice(currentbox, board)
    for cell in box
        if cell == value
            #println("Box violation")
            return false
        end
    end
    return true
end

#Uses ranges to determine what box the position is in
function determinebox(position::Tuple{Int, Int})::Int
    #Fist row of boxes
    if position[1] > 0 && position[1] < 4
        #First column of boxes
        if position[2] > 0 && position[2] < 4
            return 1
        #Middle column of boxes
        elseif position[2] > 3 && position[2] < 7
            return 2
        #Last column of boxes
        else
            return 3
        end
    #Middle row of boxes
    elseif position[1] > 4 && position[1] < 7
        if position[2] > 0 && position[2] < 4
            return 4
        elseif position[2] > 3 && position[2] < 7
            return 5
        else
            return 6
        end
    #Bottom row of boxes
    else
        if position[2] > 0 && position[2] < 4
            return 7
        elseif position[2] > 3 && position[2] < 7
            return 8
        else
            return 9
        end
    end
end

#Returns a view into a box of the board based on the given box number
function getboxslice(box::Int, board::Array{Int, 2})::Array{Int}
    slice = Dict(
        1 => board[1:3, 1:3], 
        2 => board[1:3, 4:6], 
        3 => board[1:3, 7:9], 
        4 => board[4:6, 1:3], 
        5 => board[4:6, 4:6],
        6 => board[4:6, 7:9], 
        7 => board[7:9, 1:3], 
        8 => board[7:9, 4:6], 
        9 => board[7:9, 7:9]
    )

    return slice[box]
end

function getcoords(box::Int)::Tuple{Tuple{Int, Int}, Tuple{Int, Int}}
    coords = Dict(
        1 => ((1,3), (1,3)), 
        2 => ((1,3), (4,6)), 
        3 => ((1,3), (7,9)), 
        4 => ((4,6), (1,3)), 
        5 => ((4,6), (4,6)),
        6 => ((4,6), (7,9)), 
        7 => ((7,9), (1,3)), 
        8 => ((7,9), (4,6)), 
        9 => ((7,9), (7,9))
    )

    return coords[box]
end

function originalcoords(box::Int, sliceindex::Int)::Tuple{Int, Int}
    coords = getcoords(box)
    counter = 0
    for row in coords[1][1]:coords[1][2]
        for col in coords[2][1]:coords[2][2]
            counter = counter + 1
            if counter == sliceindex
                return (row, col)
            end
        end
    end
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


    printboard(testingboard)
    # Partially filled valid board
    testingboard4 = fill(0, 9, 9)
    testingboard4[1,1] = 1
    testingboard4[1,2] = 6
    testingboard4[1,3] = 2
    testingboard4[1,4] = 7
    testingboard4[1,5] = 4
    testingboard4[1,6] = 9
    testingboard4[1,7] = 5
    testingboard4[1,8] = 3
    testingboard4[1,9] = 8
    testingboard4[2,1] = 7
    testingboard4[2,2] = 4
    testingboard4[2,3] = 9
    testingboard4[2,4] = 3
    testingboard4[2,5] = 5
    testingboard4[2,6] = 8
    testingboard4[2,7] = 6
    testingboard4[2,8] = 1
    testingboard4[2,9] = 2
    testingboard4[3,1] = 3
    testingboard4[3,2] = 5
    testingboard4[3,3] = 8
    # testingboard4[3,4] = 4
    testingboard4[3,5] = 2
    # testingboard4[3,6] = 6
    # testingboard4[3,7] = 9
    testingboard4[4,3] = 4
    testingboard4[4,9] = 5
    testingboard4[5,5] = 8
    testingboard4[5,9] = 7
    testingboard4[6,1] = 8
    testingboard4[6,5] = 1
    testingboard4[7,8] = 5
    testingboard4[7,9] = 9
    testingboard4[8,2] = 9
    testingboard4[8,6] = 1
    testingboard4[9,3] = 7
    testingboard4[9,5] = 6
    hints2::Vector{Tuple{Int, Int}} = [(1,3),(1,8),(2,2),(2,4),(2,7),(3,5),(4,3),(4,9),(5,5),
                                      (5,9),(6,1),(6,5),(7,8),(7,9),(8,2),(8,6),(9,3),
                                      (9,5)
                                      ]
    
    # printboard(testingboard)
    printboard(testingboard4)

    # False tests
    # println(validacrossboard(testingboard, 1, (7,3))) # should be false (col conflict)
    # println(validacrossboard(testingboard, 4, (6,4))) # should be false (row conflict)
    # println(validacrossboard(testingboard, 3, (2,8))) # should be false (box conflict)
    # println(validinbox(testingboard, 1, (1,1))) # should be false (box conflict)
    println(validinbox(testingboard4, 4, (3,4))) # should be false (box conflict)
    
    # True tests
    # println(validacrossboard(testingboard, 5, (8,1))) # should be true
    # println(validacrossboard(testingboard, 8, (7,1))) # should be true
    # println(validinbox(testingboard, 2, (1,4)))
    println(validincolumn(testingboard4, 4, (3,4))) # should be true
    println(validinrow(testingboard4, 4, (3,4))) # should be true

    println(determinebox((1,3))) # should be 1
    println(determinebox((3,4))) # should be 2
    println(determinebox((2,7))) # should be 3
    println(determinebox((5,3))) # should be 4
    println(determinebox((6,5))) # should be 5
    println(determinebox((6,8))) # should be 6
    println(determinebox((8,3))) # should be 7
    println(determinebox((8,5))) # should be 8
    println(determinebox((8,8))) # should be 9
end
