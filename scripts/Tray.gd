extends Node2D

const MAX_SLOTS: int = 7
var tiles: Array = []
var slot_width: int = 70
var history: Array = []

func _ready():
    get_node("Background").size = Vector2(MAX_SLOTS * slot_width + 20, 90)

func add_tile(tile) -> bool:
    if tiles.size() >= MAX_SLOTS:
        return false
    
    tile.saved_position = tile.position
    tile.saved_z = tile.z_index
    
    history.append(tile)
    tiles.append(tile)
    tile.position = Vector2(tiles.size() * slot_width + 10, 45)
    tile.get_parent().remove_child(tile)
    add_child(tile)
    
    check_matches()
    return true

func undo_last_tile():
    if history.size() > 0:
        var tile = history.pop_back()
        tiles.erase(tile)
        remove_child(tile)
        reposition_tiles()
        return tile
    return null

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
        history.erase(tile)
        tile.animate_removal()
    
    reposition_tiles()

func reposition_tiles():
    for i in range(tiles.size()):
        tiles[i].position = Vector2(i * slot_width + 10, 45)

func is_full() -> bool:
    return tiles.size() >= MAX_SLOTS

func clear():
    for tile in tiles:
        tile.queue_free()
    tiles.clear()
    history.clear()