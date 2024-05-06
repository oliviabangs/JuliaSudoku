using Mousetrap
include("boardgeneration.jl")

global original_gui_board = generatesolvableclues()
global in_progress_board = copy(original_gui_board)

mutable struct GameState
    original_board::Matrix{Int64}
    immutable_indices::Array
    current_board::Matrix{Int64}
    selected_value::Int64
    finished_game::Bool
end

function convert_1d_to_2d(idx::Int, ncols::Int)
    col, row = divrem(idx - 1, ncols)  # Subtract 1 to adjust for 1-based indexing
    return (row + 1, col + 1)  # Adding 1 because indices start from 1 in Julia
end

function find_immutable_indices(original_board::Matrix{Int64})
    indices = []

    for index in 1:length(original_board)
        if original_board[index] != 0
            push!(indices, index)
        end
    end
    return indices

end

global game = GameState(
    original_gui_board,
    find_immutable_indices(original_gui_board),
    in_progress_board,
    1, 
    false
)

function generate_child(label::String, index)::Button
    if label == "0"
        label = ""
    end 

    button = Button(Label(label))
    set_size_request!(button, Vector2f(50, 50)) # Sets button size to 50x50 pixels

    if index in 19:27 || index in 46:54
        set_margin_end!(button, 10)
    end

    if (index - 3) % 9 in (0, 3)
        set_margin_bottom!(button, 10)
    end

    data = [index, label]

    connect_signal_clicked!(on_clicked, button, data ) # Hooks up button with callback 
    return button
end

function create_spin_button()
    spin_button = SpinButton(0, 9, 1)
    set_size_request!(spin_button,Vector2f(50, 50))
    set_orientation!(spin_button, ORIENTATION_VERTICAL)
    set_value!(spin_button, 1)
    set_margin_end!(spin_button, 10)
    connect_signal_value_changed!(on_input_change, spin_button)
    return spin_button

end

function on_input_change(self::SpinButton)::Nothing
    
    game.selected_value = get_value(self)
    println("Selected value: $(game.selected_value)")
end

function on_clicked(self::Button, data)::Nothing
    index = data[1]
    label = data[2]
    set_value = string(game.selected_value)
    two_dim_index = convert_1d_to_2d(index, 9)

    if !(index in game.immutable_indices)
        if validacrossboard(game.current_board, game.selected_value, two_dim_index)

            game.current_board[index] = game.selected_value
            if game.selected_value == 0
                set_value = ""
            end
            set_child!(self, Label(set_value))
        else
            println("not a valid move!")
        end
            
    else 
        println("that is an immutable index!")
    end

    if everyspotfull(game.current_board) && boardconfigvalid(game.current_board)
        game.finished_game = true
    end
    
end

function newboard_button(window::Window)::Button
    #How the button looks
    newBoard = Button(Label("New Board"))
    set_size_request!(newBoard,Vector2f(50,100))
    set_margin!(newBoard,10)
    set_vertical_alignment!(newBoard,ALIGNMENT_START)
    set_horizontal_alignment!(newBoard,ALIGNMENT_END)
    connect_signal_clicked!(clicked_newBoard, newBoard,window)
    return newBoard
end

function clearboard_button(window::Window)::Button
    #How the button looks
    clearBoard = Button(Label("Clear Board"))
    set_size_request!(clearBoard,Vector2f(50,100))
    set_margin!(clearBoard,10)
    set_vertical_alignment!(clearBoard,ALIGNMENT_END)
    set_horizontal_alignment!(clearBoard,ALIGNMENT_START)
    connect_signal_clicked!(clicked_clearBoard, clearBoard,window)
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

global grid = generate_board(original_gui_board);

function clicked_newBoard(self::Button,window)
    println("New Board Clicked")
    
    grid = generate_board(original_gui_board);

    clearBoard = clearboard_button(window);
    exit = exit_button(window)
    newBoard = newboard_button(window)

    new_grid = update_grid(grid,newBoard,clearBoard,exit,window);

    present!(window)
    return nothing
end

function clicked_clearBoard(self::Button,window::Window)
    println("Clear Board Clicked")
    grid = generate_board(in_progress_board);

    clearBoard = clearboard_button(window)
    exit = exit_button(window)
    newBoard = newboard_button(window)

    new_grid = revert_grid(grid,newBoard,clearBoard,exit,window);
    return nothing
end

function clicked_exit(self::Button,window)
    println("Exit Clicked")
    close!(window)
    return nothing
end

function update_grid(grid::Grid,newBoard::Button,clearBoard::Button,exit::Button,window::Window)::Window
    global original_gui_board = generatesolvableclues()
    global in_progress_board = original_gui_board
    global grid = generate_board(original_gui_board)
    spin_button = create_spin_button()
    side_buttons = vbox(newBoard, exit, clearBoard)
    box = hbox(spin_button,grid,side_buttons)
    set_child!(window,box);
    return window
end

function revert_grid(grid::Grid,newBoard::Button,clearBoard::Button,exit::Button,window::Window)::Window
    grid = generate_board(original_gui_board)
    spin_button = create_spin_button()
    side_buttons = vbox(newBoard, exit, clearBoard)
    box = hbox(spin_button,grid,side_buttons)
    set_child!(window,box);
    return window
end

function generate_orignial_window(window,rand_board)::Box
    
    clearBoard = clearboard_button(window);    
    exit = exit_button(window);
    newBoard = newboard_button(window);
    spin_button = create_spin_button()
    side_buttons = vbox(newBoard, exit, clearBoard)
    box = hbox(spin_button,grid,side_buttons)
    return box
end


function create_window(app::Application)::Window
    window = Window(app)
    box = generate_orignial_window(window,original_gui_board)    
    set_child!(window,box)
    return window
end

# Still haven't figured out how to call this from main.jl
# Have to run julia gui.jl to launch gui for now
main() do app::Application
    window = create_window(app::Application)
    present!(window)
end
