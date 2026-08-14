extends Control

var board: Node
var tray: Node
var tool_panel: Node
var score_label: Label
var level_label: Label
var win_screen: Node
var lose_screen: Node
var album_bar: Node
var pause_screen: Node
var story_card: Node
var tutorial: Node
var pending_story: int = 0

func _ready():
    board = get_node("Board")
    tray = get_node("Tray")
    tool_panel = get_node("ToolPanel")
    score_label = get_node("ScoreLabel")
    level_label = get_node("LevelLabel")
    win_screen = get_node("WinScreen")
    lose_screen = get_node("LoseScreen")
    album_bar = get_node("AlbumBar")
    pause_screen = get_node("PauseScreen")
    story_card = get_node("StoryCard")
    tutorial = get_node("Tutorial")
    
    GameManager.tile_clicked.connect(_on_tile_clicked)
    tool_panel.hint_requested.connect(_on_hint)
    tool_panel.shuffle_requested.connect(_on_shuffle)
    tool_panel.undo_requested.connect(_on_undo)
    get_node("MenuButton").pressed.connect(_on_menu_pressed)
    win_screen.next_level_requested.connect(_on_next_level)
    win_screen.restart_requested.connect(_on_restart)
    lose_screen.restart_requested.connect(_on_restart)
    pause_screen.restart_pressed.connect(_on_restart)
    pause_screen.menu_pressed.connect(_on_to_menu)
    story_card.continue_pressed.connect(_on_story_done)
    
    win_screen.visible = false
    lose_screen.visible = false
    
    start_level(GameManager.current_level)
    
    if not SaveSystem.get_flags().has("tutorial_done"):
        tutorial.visible = true

func start_level(level: int):
    ThemeManager.set_chapter(CollectionManager.house_tier)
    get_node("Background").apply_theme()
    board.generate_level(level)
    tray.clear()
    HintSystem.reset_hints()
    update_ui()
    album_bar.refresh()
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
            GameManager.fail_level()
            show_lose_screen()

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
        tile.position = tile.saved_position
        tile.z_index = tile.saved_z
        board.update_blocked_tiles()
        update_ui()

func _on_menu_pressed():
    pause_screen.visible = true

func _on_to_menu():
    get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_story_done():
    start_level(GameManager.current_level)

func show_win_screen():
    win_screen.get_node("ScoreLabel").text = "Счёт: " + str(GameManager.score)
    var reward = CollectionManager.roll_win_reward()
    if reward.type == "item":
        win_screen.show_drop(reward.item, reward.caption)
    elif reward.type == "key":
        win_screen.show_key()
        pending_story = CollectionManager.house_tier
        ThemeManager.set_chapter(CollectionManager.house_tier)
    else:
        win_screen.show_coins(reward.amount)
    album_bar.refresh()
    win_screen.visible = true

func show_lose_screen():
    lose_screen.visible = true

func _on_next_level():
    if pending_story > 0:
        var tier = pending_story
        pending_story = 0
        story_card.show_story(tier)
    else:
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