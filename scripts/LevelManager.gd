extends Node

const LEVEL_CONFIGS = {
    1: {"tile_count": 144, "types": 16, "layers": 4},
    2: {"tile_count": 144, "types": 20, "layers": 4},
    3: {"tile_count": 144, "types": 24, "layers": 5},
    4: {"tile_count": 144, "types": 28, "layers": 5},
    5: {"tile_count": 144, "types": 32, "layers": 5},
    6: {"tile_count": 144, "types": 36, "layers": 6},
    7: {"tile_count": 144, "types": 40, "layers": 6},
    8: {"tile_count": 144, "types": 44, "layers": 6},
    9: {"tile_count": 144, "types": 48, "layers": 6},
    10: {"tile_count": 144, "types": 48, "layers": 6}
}

func get_level_config(level: int) -> Dictionary:
    return LEVEL_CONFIGS.get(level, LEVEL_CONFIGS[1])