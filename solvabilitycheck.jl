include("utilities.jl")

function generatesolveboard(startingboard::Array{Int, 2})::Array{Int, 2}
    board = copy(startingboard)

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
    return solvingrecursivehelper(board, (1,1), hints, false, 0)
end

function solvingrecursivehelper(board::Array{Int, 2}, pos::Tuple{Int, Int}, hints::Vector{Tuple{Int, Int}}, backtracking::Bool, numtouch::Int)::Array{Int, 2}
    # Keeping track of how many times the recusion happens to catch infinite insolvability loops before they happen
    numtouch += 1

    # Stops once every spot has a value or it appears to be unsolvable
    if everyspotfull(board) || numtouch > 10000
        return board
    # Handles when the position is not a hint
    elseif !(pos in hints)
        # Increments the value already at that location
        value::Int = board[pos[1], pos[2]] + 1

        # Checks whether that value or another is possible
        currentvalue::Int = fillcell(board, value, pos)

        # Indicates that backtracking is needed
        if currentvalue == 100
            # Negates what was at that position and moves backwared
            board[pos[1], pos[2]] = 0
            return solvingrecursivehelper(board, movebackwards(pos, 1), hints, true, numtouch)

        # Backtracking not needed
        else
            # Value update and position moves forward
            board[pos[1], pos[2]] = currentvalue
            return solvingrecursivehelper(board, moveforwards(pos, 1), hints, false, numtouch)
        end
    # Handles if the position is a hint since it can't change the hint
    else
        # Moves back past the hint if its in backtracking mode
        if backtracking
            return solvingrecursivehelper(board, movebackwards(pos, 1), hints, true, numtouch)
         # Moves forward past the hint
        else
            return solvingrecursivehelper(board, moveforwards(pos, 1), hints, false, numtouch)
        end
    end
end

function fillcell(board::Array{Int, 2}, value::Int, pos::Tuple{Int, Int})::Int
    if value > 9
        return 100
    end

    validity::Bool = validacrossboard(board, value, pos)
    if validity 
        return value
    else
        if value == 9
            return 100
        else
            return fillcell(board, value + 1, pos)
        end
    end
end

function movebackwards(pos::Tuple{Int, Int}, numberoftimes::Int)::Tuple{Int, Int}
    # First digit in tuple is row
    if pos == (1, 1)
        return (1, 1)
    end

    newrow, newcol = pos 

    for _ in 1:numberoftimes
        if newcol == 1
            newcol = 9
            newrow -= 1
        else
            newcol -= 1
        end
    end
    return (newrow, newcol)
end

function moveforwards(pos::Tuple{Int, Int}, numberoftimes::Int)::Tuple{Int, Int}
    if pos == (9, 9)
        return (9, 9)
    end

    newrow, newcol = pos 

    for _ in 1:numberoftimes
        if newcol + 1 > 9
            newcol = 1
            newrow += 1
        else
            newcol += 1
        end
    end
    return (newrow, newcol)
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

    # Board w/ only valid hints
    testingboard3 = fill(0, 9, 9)
    testingboard3[1,3] = 2
    testingboard3[1,8] = 3
    testingboard3[2,2] = 4
    testingboard3[2,4] = 3
    testingboard3[2,7] = 6
    testingboard3[3,5] = 2
    testingboard3[4,3] = 4
    testingboard3[4,9] = 5
    testingboard3[5,5] = 8
    testingboard3[5,9] = 7
    testingboard3[6,1] = 8
    testingboard3[6,5] = 1
    testingboard3[7,8] = 5
    testingboard3[7,9] = 9
    testingboard3[8,2] = 9
    testingboard3[8,6] = 1
    testingboard3[9,3] = 7
    testingboard3[9,5] = 6
    #testingboard3[9,5] = 2
    hints::Vector{Tuple{Int, Int}} = [(1,3),(1,8),(2,2),(2,4),(2,7),(3,5),(4,3),(4,9),(5,5),
                                      (5,9),(6,1),(6,5),(7,8),(7,9),(8,2),(8,6),(9,3),
                                      (9,5)
                                     ]

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
    
    # False tests
    # println(checkspotoccupied(3, 3, testingboard)) # Should be false (spot occupied)
    # println(everyspotfull(testingboard)) # Should be false (not every spot is not empty)
    
    # True tests
    # println(checkspotoccupied(3, 2, testingboard)) # Should be true (spot not occupied)
    # println(everyspotfull(testingboard2)) # Should be true (every cell is not empty)

    printboard(testingboard3)
    # printboard(testingboard4)
    solvingrecursivehelper(testingboard3, (1,1), hints, false, 0)

    # println(fillcell(testingboard3, 1, (1,1))) # Should be 1
    # println(fillcell(testingboard3, 3, (1,4))) # Should be 4
    # println(fillcell(testingboard3, 9, (7,7))) # Should be 100
    # println(fillcell(testingboard3, 10, (7,1))) # Should be 100
    # println(fillcell(testingboard4, 1, (3,4))) # Should be 1. Not 4!
    # println(fillcell(testingboard4, 4, (3,6))) # Should be 6 
    # println(fillcell(testingboard4, 9, (3,7))) # Should be 9

    # println(movebackwards((9,9), 2)) # Should be (9,7)
    # println(movebackwards((9,1), 1)) # Should be (8,9)
    # println(movebackwards((1,1), 2)) # Should be (1,1)

    # println(moveforwards((9,9), 1)) # Should be (9,9)
    # println(moveforwards((8,9), 1)) # Should be (9,1)
    # println(moveforwards((9,7), 2)) # Should be (9,9)
    
end