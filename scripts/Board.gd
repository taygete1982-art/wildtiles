extends Node2D

var tiles: Array = []
var tile_scene: PackedScene

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
    
    update_blocked_tiles()

func generate_positions(count: int) -> Array:
    var positions = []
    var layers = 3
    var per_layer = count / layers
    for layer in range(layers):
        for i in range(per_layer):
            positions.append({"x": (i % 4) + layer, "y": (i / 4) + layer, "layer": layer})
    return positions

func get_tile_types(count: int) -> Array:
    var all_types = ["giraffe", "zebra", "sloth", "elephant", "rhino", "panda",
                     "parrot", "crocodile", "monkey", "snake", "owl", "frog"]
    return all_types.slice(0, count)

func clear_board():
    for tile in tiles:
        tile.queue_free()
    tiles.clear()

func is_tile_available(tile) -> bool:
    for other_tile in tiles:
        if other_tile == tile:
            continue
        if other_tile.z_index > tile.z_index:
            var dx = abs(other_tile.position.x - tile.position.x)
            var dy = abs(other_tile.position.y - tile.position.y)
            if dx < 60 and dy < 60:
                return false
    return true

func update_blocked_tiles():
    for tile in tiles:
        tile.set_blocked(not is_tile_available(tile))

func get_hint():
    var available = []
    for tile in tiles:
        if is_tile_available(tile):
            available.append(tile)
    if available.size() > 0:
        return available[randi() % available.size()]
    return null

func shuffle_board():
    var types = []
    for tile in tiles:
        types.append(tile.tile_type)
    types.shuffle()
    for i in range(tiles.size()):
        tiles[i].setup(types[i])
    update_blocked_tiles()