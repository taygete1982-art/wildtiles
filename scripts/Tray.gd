extends Node2D
class_name Tray

const MAX_SLOTS: int = 7
var tiles: Array = []
var slot_width: int = 70

func _ready():
    .size = Vector2(MAX_SLOTS * slot_width + 20, 90)

func add_tile(tile: Tile) -> bool:
    if tiles.size() >= MAX_SLOTS:
        return false
    
    tiles.append(tile)
    tile.position = Vector2(tiles.size() * slot_width + 10, 45)
    tile.get_parent().remove_child(tile)
    add_child(tile)
    
    check_matches()
    return true

func check_matches():
    var counts = {}
    for tile in tiles:
        counts[tile.tile_type] = counts.get(tile.tile_type, 0) + 1
    
    for type in counts:
        if counts[type] >= 3:
            remove_tiles_of_type(type)
            GameManager.add_score(10)

func remove_tiles_of_type(type: String):
    var to_remove = []
    for tile in tiles:
        if tile.tile_type == type:
            to_remove.append(tile)
    
    for tile in to_remove:
        tiles.erase(tile)
        tile.queue_free()
    
    reposition_tiles()

func reposition_tiles():
    for i in range(tiles.size()):
        tiles[i].position = Vector2(i * slot_width + 10, 45)

func is_full() -> bool:
    return tiles.size() >= MAX_SLOTS
