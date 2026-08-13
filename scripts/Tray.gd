extends Node2D
class_name Tray

const MAX_SLOTS: int = 7
var tiles: Array = []

func add_tile(tile: Tile) -> bool:
    if tiles.size() >= MAX_SLOTS:
        return false
    tiles.append(tile)
    check_matches()
    return true

func check_matches():
    var counts = {}
    for tile in tiles:
        counts[tile.tile_type] = counts.get(tile.tile_type, 0) + 1
    
    for type in counts:
        if counts[type] >= 3:
            remove_tiles_of_type(type)

func remove_tiles_of_type(type: String):
    var to_remove = []
    for tile in tiles:
        if tile.tile_type == type:
            to_remove.append(tile)
    for tile in to_remove:
        tiles.erase(tile)
        tile.queue_free()

func is_full() -> bool:
    return tiles.size() >= MAX_SLOTS
