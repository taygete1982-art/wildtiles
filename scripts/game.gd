extends Control

@onready var board = 
@onready var tray = 
@onready var score_label = 

func _ready():
    GameManager.tile_clicked.connect(_on_tile_clicked)
    update_score_display()

func _on_tile_clicked(tile):
    if tray.add_tile(tile):
        tile.get_parent().remove_child(tile)
        update_score_display()
        
        if board.tiles.size() == 0:
            GameManager.complete_level()
    else:
        GameManager.fail_level()

func update_score_display():
    score_label.text = "Счёт: " + str(GameManager.score)
