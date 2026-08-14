extends Node

const TIER_CONFIGS = {
    1: {"tile_count": 144, "types": 16, "layers": 4},
    2: {"tile_count": 144, "types": 24, "layers": 5},
    3: {"tile_count": 144, "types": 32, "layers": 5},
    4: {"tile_count": 144, "types": 48, "layers": 6}
}

func get_level_config(_level: int) -> Dictionary:
    return TIER_CONFIGS.get(CollectionManager.house_tier, TIER_CONFIGS[1])