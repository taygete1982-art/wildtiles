extends Node2D
class_name Tile

var tile_type: String = ""
var is_selected: bool = false
var is_clicked: bool = false
var is_blocked: bool = false

func setup(type: String):
    tile_type = type
    .text = type.substr(0, 2).to_upper()

func _on_area_2d_input_event(viewport, event, shape_idx):
    if event is InputEventMouseButton and event.pressed:
        on_tile_clicked()

func on_tile_clicked():
    if is_blocked:
        print("Плитка заблокирована!")
        return
    
    if not is_clicked:
        is_clicked = true
        GameManager.on_tile_clicked(self)

func set_blocked(blocked: bool):
    is_blocked = blocked
    if blocked:
        modulate = Color(0.5, 0.5, 0.5, 1)
    else:
        modulate = Color(1, 1, 1, 1)
