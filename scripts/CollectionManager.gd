extends Node

const ITEMS = ["chair", "sofa", "table", "bed", "lamp", "tv",
               "shelf", "plant", "clock", "fridge", "wardrobe", "sink"]
const VARIANTS = 4
const BASE_CHANCE = 0.35

var collection = {}
var pity = 0

func owns(item: String) -> bool:
    return collection.has(item)

func get_variant(item: String) -> int:
    return collection.get(item, -1)

func add(item: String, variant: int):
    collection[item] = variant
    persist()

func persist():
    SaveSystem.save_game({"collection": collection, "level": GameManager.current_level})

func try_load_save():
    var data = SaveSystem.load_game()
    if data.has("collection"):
        collection = data["collection"]
    if data.has("level"):
        GameManager.current_level = data["level"]

func roll_drop():
    pity += 1
    var chance = BASE_CHANCE + pity * 0.05
    if randf() <= chance:
        pity = 0
        var item = ITEMS[randi() % ITEMS.size()]
        var variant = randi() % VARIANTS
        return {"item": item, "variant": variant}
    return null