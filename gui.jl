using Mousetrap

function generate_child(label::String)::Button
    
    button = Button(Label(label))
    set_size_request!(button, Vector2f(50, 50))
    
    connect_signal_clicked!(on_clicked, button, label)
    return button
end

function on_clicked(self::Button, data)
    println(data)
end

main() do app::Application
    random_array = rand(1:9, 9, 9)
    window = Window(app)
    
    grid = Grid()

    cells = []
    for i in 1:9
        push!(cells, generate_child(string(i)))
    end
    
    row = 1
    column = 1

    # for row in eachrow(random_array)

        

    for index in 1:9
        Mousetrap.insert_at!(grid, cells[index], column, row, 1, 1)
        column += 1
        if index % 3 == 0
            row += 1
            column = 1
        end
    end
    box = hbox(grid)
    set_spacing!(box, 10)
    set_child!(window, box)
    present!(window)
end