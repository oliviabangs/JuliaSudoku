using Mousetrap

function generate_child(label::String, index)::Button
    
    button = Button(Label(label))
    set_size_request!(button, Vector2f(50, 50)) # Sets button size to 50x50 pixels
    data = [label, index] # Relevant information for callback function for when button is clicked
    connect_signal_clicked!(on_clicked, button, data ) # Hooks up button with callback 
    return button
end

function on_clicked(self::Button, data)
    # Temporarily shows value in cell and index, will eventually create a text box that prompts user for new number
    println("value: $(data[1]), index: $(data[2])")
end

# Still haven't figured out how to call this from main.jl
# Have to run julia gui.jl to launch gui for now
main() do app::Application

    window = Window(app) 

    grid = Grid() # Declaring grid where Button objects will eventually be pushed into

    rand_board = rand(1:9, 9, 9) # Using a random board for now
    display(rand_board) # Showing it in terminal to compare against GUI

    cells = [] # Array where Button objects are temporarily stored before going in the grid
    for i in 1:length(rand_board)
        newCell = generate_child(string(rand_board[i]), i) # Creates button object displaying proper value and storing its index
        push!(cells, newCell)
    end
    
    row = 1
    column = 1

    for index in 1:length(cells)
        Mousetrap.insert_at!(grid, cells[index], column, row, 1, 1) # Inserts cell from cells array into grid at given col and row position with relative size 1,1
        
        # Funny math to properly align cells
        row += 1
        if index % 9 == 0
            row = 1
            column += 1
        end
    end
    
    set_child!(window, grid)
    present!(window)
endusing Mousetrap
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