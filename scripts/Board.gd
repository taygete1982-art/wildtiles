extends Node2D
class_name Board

var tiles: Array = []
var tile_scene: PackedScene
var grid: Dictionary = {}

func _ready():
    tile_scene = load("res://scenes/Tile.tscn")

func generate_level(level: int):
    clear_board()
    var config = LevelManager.get_level_config(level)
    var types = get_tile_types(config.types)
    var positions = generate_positions(config.tile_count)
    
    for i in range(config.tile_count):
        var pos = positions[i]
        var tile = tile_scene.instantiate()
        tile.setup(types[i % types.size()])
        tile.position = Vector2(pos.x * 80 + 40, pos.y * 80 + 40)
        tile.z_index = pos.layer
        add_child(tile)
        tiles.append(tile)
        grid[Vector3(pos.x, pos.y, pos.layer)] = tile

func generate_positions(count: int) -> Array:
    var positions = []
    var layers = 3
    var per_layer = count / layers
    
    for layer in range(layers):
        for i in range(per_layer):
            var x = (i % 4) + layer
            var y = (i / 4) + layer
            positions.append({"x": x, "y": y, "layer": layer})
    
    return positions

func get_tile_types(count: int) -> Array:
    var all_types = ["giraffe", "lion", "zebra", "meerkat", "acacia", 
                     "sloth", "tiger", "chameleon", "monstera", 
                     "camel", "fennec", "cactus"]
    return all_types.slice(0, count)

func clear_board():
    for tile in tiles:
        tile.queue_free()
    tiles.clear()
    grid.clear()

func is_tile_available(tile: Tile) -> bool:
    var tile_pos = tile.position
    for other_tile in tiles:
        if other_tile == tile:
            continue
        if other_tile.z_index > tile.z_index:
            var dx = abs(other_tile.position.x - tile_pos.x)
            var dy = abs(other_tile.position.y - tile_pos.y)
            if dx < 60 and dy < 60:
                return false
    return true
