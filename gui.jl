using Mousetrap
include("boardgeneration.jl")

function newboard_button(board)::Button
    #How the button looks
    newBoard = Button(Label("New Board"))
    set_size_request!(newBoard,Vector2f(50,100))
    set_margin!(newBoard,50)
    set_vertical_alignment!(newBoard,ALIGNMENT_CENTER)
    set_horizontal_alignment!(newBoard,ALIGNMENT_START)
    
    #Call to change the board generated
    board_two = [0,1]
    
    connect_signal_clicked!(clicked_newBoard, newBoard, board_two)
    return newBoard
end

function clearboar_button(board)::Button
    #How the button looks
    clearBoard = Button(Label("Clear Board"))
    set_size_request!(clearBoard,Vector2f(50,100))
    set_margin!(clearBoard,50)
    set_vertical_alignment!(clearBoard,ALIGNMENT_CENTER)
    set_horizontal_alignment!(clearBoard,ALIGNMENT_CENTER)

    #Call to remove the changes
    board_ten = [0,10]
    connect_signal_clicked!(clicked_clearBoard, clearBoard, board_ten)
    return clearBoard
end

function exit_button()::Button
    #How the button looks
    exit = Button(Label("Exit"))
    set_size_request!(exit,Vector2f(50,100))
    set_margin!(exit,50)
    set_vertical_alignment!(exit,ALIGNMENT_CENTER)
    set_horizontal_alignment!(exit,ALIGNMENT_END)

    return exit
end

function clicked_newBoard(self::Button,board)
    println("Current board: $board")
    board[2] += 1
    println("New board:$board")
    return nothing
end

function clicked_clearBoard(self::Button,board)
    println("Chaneged board:$board")
    if(board[2] != 0)
        board[2] -= 1
    end
    println("Cleared board:$board")
    return nothing
end

main() do app::Application
    window = Window(app)
    
    board = [0,0];
    
    newBoard = newboard_button(board);
    clearBoard = clearboar_button(board);
    exit = exit_button();

    println("The first board: $board")

    connect_signal_clicked!(exit,newBoard) do exit::Button,newBoard::Button
        println("exit clicked")
    end


    set_child!(window, hbox(newBoard,exit,clearBoard))
    present!(window)
end