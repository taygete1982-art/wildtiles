extends Node2D
class_name Board

var tiles: Array = []
var tile_scene: PackedScene

func _ready():
    tile_scene = load("res://scenes/Tile.tscn")
    generate_board()

func generate_board():
    var types = ["giraffe", "lion", "zebra", "meerkat", "acacia", "sloth"]
    for i in range(12):
        var tile = tile_scene.instantiate()
        tile.setup(types[i % types.size()])
        tile.position = Vector2(100 + (i % 4) * 100, 100 + (i / 4) * 100)
        add_child(tile)
        tiles.append(tile)
