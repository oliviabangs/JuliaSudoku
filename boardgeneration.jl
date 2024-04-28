include("utilities.jl")
include("solvabilitycheck.jl")

function generatesolvableclues()
    clues = generateeighteen()
    printboard(clues)
        
    solution = generatesolveboard(clues)

    while !everyspotfull(solution) || !boardconfigvalid(solution)
        clues = generateeighteen()
        solution = generatesolveboard(clues)
    end

    printboard(clues)
    printboard(solution)

    return clues
end

function generateeighteen()::Matrix{Int}
    takennums = Dict(1 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0, 9 => 0)
    startingclues::Vector{Tuple{Int,Int,Int}} = empty!([(0,0,0)])
    startingboard = fill(0, 9, 9)

    board = placevalues(1, takennums, startingclues, startingboard)

    if boardconfigvalid(board)
        return board
    else
        printboard(board)
        println("Failed to produce a valid board")
    end

end

function placevalues(box::Int, takennums::Dict{Int, Int}, clues, board::Matrix{Int})::Matrix{Int}
    if length(clues) < 18
        boxslice = getboxslice(box, board)
        choosennum = rand(1:9)

        if takennums[choosennum] > 1
            choosennum = rand(1:9)
            while takennums[choosennum] > 1
                println("stuck in while 1")
                choosennum = rand(1:9)
            end
        end

        choosenspot = rand(1:9)
        if boxslice[choosenspot] != 0 
            choosenspot = rand(1:9)
            while boxslice[choosenspot] != 0
                println("stuck in while 2")
                choosenspot = rand(1:9)
            end
        end

        coordsinboard = originalcoords(box, choosenspot)

        if validacrossboard(board, choosennum, coordsinboard) && board[coordsinboard[1], coordsinboard[2]] == 0
            board[coordsinboard[1], coordsinboard[2]] = choosennum
            takennums[choosennum] = takennums[choosennum] + 1
            
            push!(clues, (coordsinboard[1], coordsinboard[2], choosennum))
            if box == 9
                placevalues(1, takennums, clues, board)
            else
                placevalues(box + 1, takennums, clues, board)
            end
                
        else
            placevalues(box, takennums, clues, board)
        end
    end 
    board
end