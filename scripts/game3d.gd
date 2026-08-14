extends Node3D

var board: Node = null
var cam: Camera3D = null
var tray: Node = null
var tool_panel: Node = null
var score_label: Label = null
var level_label: Label = null
var win_screen: Node = null
var lose_screen: Node = null
var album_bar: Node = null
var level: int = 0

func _ready():
    board = $Board3D
    cam = $Camera3D
    
    var env = Environment.new()
    env.background_mode = Environment.BG_COLOR
    env.background_color = Color(0.16, 0.05, 0.09)
    var we = WorldEnvironment.new()
    we.environment = env
    add_child(we)
    
    var light = DirectionalLight3D.new()
    light.shadow_enabled = false
    light.rotation_degrees = Vector3(-50, -20, 0)
    light.light_energy = 1.4
    add_child(light)
    
    var fill = DirectionalLight3D.new()
    fill.shadow_enabled = false
    fill.rotation_degrees = Vector3(-60, 140, 0)
    fill.light_energy = 0.5
    fill.light_color = Color(1.0, 0.85, 0.7)
    add_child(fill)
    
    var table = MeshInstance3D.new()
    var tm = PlaneMesh.new()
    tm.size = Vector2(40, 40)
    table.mesh = tm
    var tmat = StandardMaterial3D.new()
    tmat.albedo_color = Color(0.38, 0.22, 0.24)
    table.material_override = tmat
    table.position = Vector3(3, -0.08, 3.8)
    add_child(table)
    
    cam.position = Vector3(3.0, -2.6, 10.5)
    cam.look_at(Vector3(3.0, 3.9, 0.0), Vector3.UP)
    cam.fov = 50
    
    var ui = $UILayer/UIRoot
    tray = ui.get_node("TrayUI")
    tool_panel = ui.get_node("ToolPanel")
    score_label = ui.get_node("ScoreLabel")
    level_label = ui.get_node("LevelLabel")
    win_screen = ui.get_node("WinScreen")
    lose_screen = ui.get_node("LoseScreen")
    album_bar = ui.get_node("AlbumBar")
    
    GameManager.tile_clicked.connect(_on_tile_clicked)
    tool_panel.hint_requested.connect(_on_hint)
    tool_panel.shuffle_requested.connect(_on_shuffle)
    tool_panel.undo_requested.connect(_on_undo)
    win_screen.next_level_requested.connect(_on_next_level)
    win_screen.restart_requested.connect(_on_restart)
    lose_screen.restart_requested.connect(_on_restart)
    
    win_screen.visible = false
    lose_screen.visible = false
    
    start_level(GameManager.current_level)

func start_level(lvl: int):
    level = lvl
    board.generate_level(level)
    tray.clear_all()
    HintSystem.reset_hints()
    update_ui()
    album_bar.refresh()
    win_screen.visible = false
    lose_screen.visible = false

func _on_tile_clicked(tile):
    if GameManager.is_game_over:
        return
    if board.is_tile_available(tile):
        if tray.add_entry(tile.tile_type, tile):
            board.take(tile)
            board.update_blocked()
            update_ui()
            if board.remaining() == 0:
                GameManager.complete_level()
                show_win_screen()
        else:
            GameManager.fail_level()
            show_lose_screen()

func _on_hint():
    if HintSystem.use_hint():
        var t = board.get_hint()
        if t:
            var tw = create_tween()
            tw.tween_property(t, "scale", Vector3(1.15, 1.15, 1.15), 0.15)
            tw.tween_property(t, "scale", Vector3(1, 1, 1), 0.15)
        update_tool_buttons()

func _on_shuffle():
    board.shuffle_board()

func _on_undo():
    var tile = tray.undo_entry()
    if tile and is_instance_valid(tile):
        board.restore(tile)
        board.update_blocked()
        update_ui()

func show_win_screen():
    win_screen.get_node("ScoreLabel").text = "Счёт: " + str(GameManager.score)
    var reward = CollectionManager.roll_win_reward()
    if reward.type == "item":
        win_screen.show_drop(reward.item, reward.caption)
    elif reward.type == "key":
        win_screen.show_key()
    else:
        win_screen.show_coins(reward.amount)
    album_bar.refresh()
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
    var btn = tool_panel.get_node("HintButton")
    btn.text = "Подсказка (" + str(HintSystem.hint_uses) + ")"