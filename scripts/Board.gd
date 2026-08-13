extends Node2D

var tiles: Array = []
var tile_scene: PackedScene

func _ready():
    tile_scene = load("res://scenes/Tile.tscn")

func generate_level(level: int):
    clear_board()
    var config = LevelManager.get_level_config(level)
    var type_list = build_tile_list(config.tile_count, config.types)
    var positions = generate_positions(config.tile_count, config.layers)
    
    for i in range(config.tile_count):
        var pos = positions[i]
        var tile = tile_scene.instantiate()
        tile.setup(type_list[i])
        tile.position = Vector2(pos.x + 60, pos.y + 60 - pos.layer * 6)
        tile.z_index = pos.layer * 10
        add_child(tile)
        tiles.append(tile)
    
    update_blocked_tiles()

func build_tile_list(count: int, num_types: int) -> Array:
    var list = []
    var types = get_tile_types(num_types)
    var groups = int(floorf(float(count) / 3.0))
    for g in range(groups):
        var t = types[g % types.size()]
        list.append(t)
        list.append(t)
        list.append(t)
    list.shuffle()
    return list

# Верхний слой со смещением в полплитки накрывает нижние
func generate_positions(count: int, layers: int) -> Array:
    var positions = []
    var per_layer = int(floorf(float(count) / float(layers)))
    var extra = count - per_layer * layers
    var cols = 5
    
    for layer in range(layers):
        var n = per_layer + (1 if layer < extra else 0)
        for i in range(n):
            var col = i % cols
            var row = int(floorf(float(i) / float(cols)))
            positions.append({
                "x": col * 80 + layer * 40,
                "y": row * 80 + layer * 40,
                "layer": layer
            })
    return positions

func get_tile_types(count: int) -> Array:
    var all_types = ["chair", "sofa", "table", "bed", "lamp", "tv",
                     "shelf", "plant", "clock", "fridge", "wardrobe", "sink"]
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
            if dx < 70 and dy < 70:
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