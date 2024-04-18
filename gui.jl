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
end