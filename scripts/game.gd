extends Control

var board: Node
var tray: Node
var tool_panel: Node
var score_label: Label
var level_label: Label
var win_screen: Node
var lose_screen: Node

func _ready():
    board = get_node("Board")
    tray = get_node("Tray")
    tool_panel = get_node("ToolPanel")
    score_label = get_node("ScoreLabel")
    level_label = get_node("LevelLabel")
    win_screen = get_node("WinScreen")
    lose_screen = get_node("LoseScreen")
    
    GameManager.tile_clicked.connect(_on_tile_clicked)
    GameManager.level_completed.connect(_on_level_completed)
    GameManager.game_over.connect(_on_game_over)
    
    tool_panel.hint_requested.connect(_on_hint)
    tool_panel.shuffle_requested.connect(_on_shuffle)
    tool_panel.undo_requested.connect(_on_undo)
    
    win_screen.next_level_requested.connect(_on_next_level)
    win_screen.restart_requested.connect(_on_restart)
    lose_screen.restart_requested.connect(_on_restart)
    
    win_screen.visible = false
    lose_screen.visible = false
    
    start_level(GameManager.current_level)

func start_level(level: int):
    board.generate_level(level)
    tray.clear()
    HintSystem.reset_hints()
    update_ui()
    win_screen.visible = false
    lose_screen.visible = false

func _on_tile_clicked(tile):
    if GameManager.is_game_over:
        return
    
    if board.is_tile_available(tile):
        if tray.add_tile(tile):
            board.tiles.erase(tile)
            board.update_blocked_tiles()
            update_ui()
            
            if board.tiles.size() == 0:
                GameManager.complete_level()
                show_win_screen()
    else:
        print("Плитка недоступна!")

func _on_hint():
    if HintSystem.use_hint():
        var hint_tile = board.get_hint()
        if hint_tile:
            hint_tile.animate_hint()
        update_tool_buttons()

func _on_shuffle():
    board.shuffle_board()

func _on_undo():
    var tile = tray.undo_last_tile()
    if tile:
        tile.is_clicked = false
        board.tiles.append(tile)
        board.add_child(tile)
        board.update_blocked_tiles()
        update_ui()

func _on_level_completed():
    pass

func _on_game_over():
    pass

func show_win_screen():
    win_screen.get_node("ScoreLabel").text = "Счёт: " + str(GameManager.score)
    win_screen.visible = true

func show_lose_screen():
    lose_screen.visible = true

func _on_next_level():
    start_level(GameManager.current_level)

func _on_restart():
    GameManager.reset_game()
    start_level(GameManager.current_level)

func update_ui():
    score_label.text = "Счёт: " + str(GameManager.score)
    level_label.text = "Уровень: " + str(GameManager.current_level)
    update_tool_buttons()

func update_tool_buttons():
    tool_panel.get_node("HintButton").text = "Подсказка (" + str(HintSystem.hint_uses) + ")"