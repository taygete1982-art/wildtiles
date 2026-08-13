extends Node

const LEVEL_CONFIGS = {
    1: {"tile_count": 12, "types": 4, "layers": 2},
    2: {"tile_count": 15, "types": 5, "layers": 2},
    3: {"tile_count": 18, "types": 6, "layers": 3},
    4: {"tile_count": 21, "types": 6, "layers": 3},
    5: {"tile_count": 24, "types": 8, "layers": 3},
    6: {"tile_count": 27, "types": 8, "layers": 4},
    7: {"tile_count": 30, "types": 10, "layers": 4},
    8: {"tile_count": 33, "types": 10, "layers": 4},
    9: {"tile_count": 36, "types": 12, "layers": 5},
    10: {"tile_count": 42, "types": 12, "layers": 5}
}

func get_level_config(level: int) -> Dictionary:
    return LEVEL_CONFIGS.get(level, LEVEL_CONFIGS[1])