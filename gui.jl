using Mousetrap
main() do app::Application
    window = Window(app)

    button = Button()
    connect_signal_clicked!(button) do self::Button
        println("clicked")
    end
    set_child!(window,button)
    present!(window)
end

