extends Node2D
class_name Tile

var tile_type: String = ""
var is_selected: bool = false

func setup(type: String):
    tile_type = type

func select():
    is_selected = true

func deselect():
    is_selected = false
