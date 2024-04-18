using Mousetrap
main() do app::Application
    window = Window(app)
    set_child!(window,Label("Hello World"))
    present!(window)
end
#function main()
    #gameboard = fill(' ', 9, 9)
  
#end