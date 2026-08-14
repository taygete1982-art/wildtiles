extends Node2D

var tiles: Array = []
var tile_scene: PackedScene

func _ready():
    tile_scene = load("res://scenes/Tile.tscn")

func generate_level(level: int):
    clear_board()
    var config = LevelManager.get_level_config(level)
    var positions = generate_positions(config.tile_count, config.layers)
    var groups = build_groups(config.tile_count, config.types)
    
    var assignment = try_generate_solvable(positions, groups)
    if assignment.is_empty():
        assignment = fallback_assignment(positions, groups)
    
    for pos in positions:
        var tile = tile_scene.instantiate()
        tile.setup(assignment[pos.id])
        tile.apply_layer(pos.layer)
        tile.position = Vector2(pos.x + 160, pos.y + 80 - pos.layer * 4)
        tile.z_index = pos.layer * 10
        add_child(tile)
        tiles.append(tile)
    
    update_blocked_tiles()

func try_generate_solvable(positions: Array, groups: Array) -> Dictionary:
    for attempt in range(8):
        var remaining = positions.duplicate(true)
        var seq = groups.duplicate()
        seq.shuffle()
        var assign = {}
        var ok = true
        
        while remaining.size() > 0:
            var free = []
            for i in range(remaining.size()):
                if is_free_pos(remaining[i], remaining):
                    free.append(i)
            if free.size() < 3:
                ok = false
                break
            free.shuffle()
            var t = seq.pop_back()
            var picked = [free[0], free[1], free[2]]
            for pi in picked:
                assign[remaining[pi].id] = t
            picked.sort()
            for k in range(picked.size() - 1, -1, -1):
                remaining.remove_at(picked[k])
        if ok:
            return assign
    return {}

func fallback_assignment(positions: Array, groups: Array) -> Dictionary:
    var flat = []
    for g in groups:
        flat.append(g)
        flat.append(g)
        flat.append(g)
    flat.shuffle()
    var assign = {}
    for i in range(positions.size()):
        assign[positions[i].id] = flat[i]
    return assign

func is_free_pos(pos: Dictionary, remaining: Array) -> bool:
    for other in remaining:
        if other == pos:
            continue
        if other.layer > pos.layer:
            var dx = abs(other.x - pos.x)
            var dy = abs(other.y - pos.y)
            if dx < 55 and dy < 70:
                return false
    return true

func build_groups(count: int, num_types: int) -> Array:
    var types = get_tile_types(num_types)
    var groups = []
    var n = int(floorf(float(count) / 3.0))
    for g in range(n):
        groups.append(types[g % types.size()])
    return groups

# Вертикальные плитки 58x80, слой со смещением в полплитки
func generate_positions(count: int, layers: int) -> Array:
    var positions = []
    var per_layer = int(floorf(float(count) / float(layers)))
    var extra = count - per_layer * layers
    var cols = 6
    var sx = 62
    var sy = 80
    var hx = sx * 0.5
    var hy = sy * 0.5
    var id = 0
    
    for layer in range(layers):
        var n = per_layer + (1 if layer < extra else 0)
        for i in range(n):
            var col = i % cols
            var row = int(floorf(float(i) / float(cols)))
            positions.append({
                "id": id,
                "x": col * sx + layer * hx,
                "y": row * sy + layer * hy,
                "layer": layer
            })
            id += 1
    return positions

func get_tile_types(count: int) -> Array:
    var p = CollectionManager.PATIENTS.duplicate()
    p.shuffle()
    return p.slice(0, count)

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
            if dx < 55 and dy < 70:
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
        tiles[i].apply_layer(int(tiles[i].z_index / 10))
    update_blocked_tiles()