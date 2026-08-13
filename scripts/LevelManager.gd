extends Node

const LEVEL_CONFIGS = {
    1: {"tile_count": 96, "types": 4, "layers": 4},
    2: {"tile_count": 96, "types": 5, "layers": 4},
    3: {"tile_count": 96, "types": 6, "layers": 4},
    4: {"tile_count": 96, "types": 8, "layers": 5},
    5: {"tile_count": 96, "types": 8, "layers": 5},
    6: {"tile_count": 96, "types": 10, "layers": 5},
    7: {"tile_count": 96, "types": 10, "layers": 6},
    8: {"tile_count": 96, "types": 12, "layers": 6},
    9: {"tile_count": 96, "types": 12, "layers": 6},
    10: {"tile_count": 96, "types": 12, "layers": 6}
}

func get_level_config(level: int) -> Dictionary:
    return LEVEL_CONFIGS.get(level, LEVEL_CONFIGS[1])