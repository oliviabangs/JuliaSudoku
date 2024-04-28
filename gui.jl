using Mousetrap

function newboard_button(board)::Button
    newBoard = Button(Label("New Board"))
    set_size_request!(newBoard,Vector2f(50,100))
    set_vertical_alignment!(newBoard,ALIGNMENT_CENTER)
    set_horizontal_alignment!(newBoard,ALIGNMENT_START)
    board = [0,1]
    connect_signal_clicked!(on_clicked, newBoard, board)
    return newBoard
end


function on_clicked(self::Button,board)
    println("board: $board")
end

main() do app::Application
    window = Window(app)

    board = [0,0];
    
    newBoard = newboard_button(board);
    clearBoard = Button(Label("Clear Board"))
    exit = Button(Label("Exit"))

    connect_signal_clicked!(newBoard,exit) do newBoard::Button, exit::Button
        println("board: $board")
        newboard_button(board)
        set_signal_clicked_blocked!(newBoard,true)
        emit_signal_clicked(exit)
        set_signal_clicked_blocked!(newBoard,false)

    end

    connect_signal_clicked!(exit,newBoard) do exit::Button,newBoard::Button
        println("exit clicked")

        set_signal_clicked_blocked!(exit,true)
        emit_signal_clicked(newBoard)
        set_signal_clicked_blocked!(exit,false)
    end

    connect_signal_clicked!(clearBoard,exit) do clearBoard::Button,exit::Button
        println("clearBoard clicked")

        set_signal_clicked_blocked!(clearBoard,true)
        emit_signal_clicked(exit)
        set_signal_clicked_blocked!(clearBoard,false)

    end

    set_child!(window, hbox(newBoard,exit,clearBoard))
    present!(window)
end