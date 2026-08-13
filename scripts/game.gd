extends Control

@onready var board = 
@onready var tray = 
@onready var score_label = 
@onready var level_label = 

func _ready():
    GameManager.tile_clicked.connect(_on_tile_clicked)
    GameManager.level_completed.connect(_on_level_completed)
    GameManager.game_over.connect(_on_game_over)
    
    start_level(GameManager.current_level)

func start_level(level: int):
    board.generate_level(level)
    update_ui()

func _on_tile_clicked(tile):
    if board.is_tile_available(tile):
        if tray.add_tile(tile):
            board.tiles.erase(tile)
            update_ui()
            
            if board.tiles.size() == 0:
                GameManager.complete_level()
    else:
        print("Плитка недоступна!")

func _on_level_completed():
    start_level(GameManager.current_level)
    update_ui()

func _on_game_over():
    print("Игра окончена!")

func update_ui():
    score_label.text = "Счёт: " + str(GameManager.score)
    level_label.text = "Уровень: " + str(GameManager.current_level)
