using Mousetrap
include("boardgeneration.jl")

boardUpdate = false;
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



function newboard_button(board)::Button
    #How the button looks
    newBoard = Button(Label("New Board"))
    set_size_request!(newBoard,Vector2f(50,100))
    set_margin!(newBoard,10)
    set_vertical_alignment!(newBoard,ALIGNMENT_START)
    set_horizontal_alignment!(newBoard,ALIGNMENT_END)
    connect_signal_clicked!(clicked_newBoard, newBoard,board)
    return newBoard
end

function clearboard_button(board)::Button
    #How the button looks
    clearBoard = Button(Label("Clear Board"))
    set_size_request!(clearBoard,Vector2f(50,100))
    set_margin!(clearBoard,10)
    set_vertical_alignment!(clearBoard,ALIGNMENT_END)
    set_horizontal_alignment!(clearBoard,ALIGNMENT_START)
    connect_signal_clicked!(clicked_clearBoard, clearBoard,board)
    return clearBoard
end

function exit_button(window)::Button
    #How the button looks
    exit = Button(Label("Exit Sudoku"))
    set_size_request!(exit,Vector2f(50,100))
    set_margin!(exit,10)
    set_horizontal_alignment!(exit,ALIGNMENT_END)
    set_vertical_alignment!(exit,ALIGNMENT_START)
    connect_signal_clicked!(clicked_exit, exit,window)
    return exit
end

function clicked_newBoard(self::Button,board)
    println("New Board Clicked")
    global boardUpdate = true
    second_board = generatesolvableclues()
    new_board = generate_board(second_board)
    return nothing
end

function clicked_clearBoard(self::Button,board)
    println("Clear Board Clicked")
    global boardUpdate = false
    second_board = generatesolvableclues()
    new_board = generate_board(second_board)
    return nothing
end

function clicked_exit(self::Button,window)
    println("Exit Clicked")
    close!(window)
    return nothing
end

function generate_board(board::Matrix{Int})::Grid
    grid = Grid() # Declaring grid where Button objects will eventually be pushed into
    display(board) # Showing it in terminal to compare against GUI

    cells = fill_in_gui_board(board)

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

    return grid
    
end


function fill_in_gui_board(board)::Array
    cells = [] # Array where Button objects are temporarily stored before going in the grid
    for i in 1:length(board)
        newCell = generate_child(string(board[i]), i) # Creates button object displaying proper value and storing its index
        push!(cells, newCell)
    end
    return cells
end

function set_box(grid::Grid,newBoard:: Button,clearBoard:: Button, exit:: Button):: Box
    box = hbox(grid,vbox(newBoard,clearBoard,exit))
    return box
end


function generate_orignial_window(window,rand_board)::Box
    rand_board = generatesolvableclues() # Using a random board for now
    grid = generate_board(rand_board);

    newBoard = newboard_button(rand_board);
    clearBoard = clearboard_button(rand_board);    
    exit = exit_button(window);
    box = set_box(grid,newBoard,clearBoard,exit)
    return box
end

function update_board_window(window)::Box
    rand_board = generatesolvableclues() # Using a random board for now
    grid = generate_board(rand_board);

    newBoard = newboard_button(rand_board);
    clearBoard = clearboard_button(rand_board);    
    exit = exit_button(window);
    box = set_box(grid,newBoard,clearBoard,exit)
    return box
end

function generate_window(window::Window)::Window 
    board_01 = generatesolvableclues()
    if(boardUpdate == false)
        box = generate_orignial_window(window,board_01)    
    else
        box = update_board_window(window)
    end

    set_child!(window,box)
    return window
end

# Still haven't figured out how to call this from main.jl
# Have to run julia gui.jl to launch gui for now
main() do app::Application
    window = Window(app) 
    set_child!(window,generate_window(window))
    present!(window)
end
