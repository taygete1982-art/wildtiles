extends Node

const ITEMS = ["chair", "sofa", "table", "bed", "lamp", "tv",
               "shelf", "plant", "clock", "fridge", "wardrobe", "sink"]
const VARIANTS = 4
const HOUSE_NAMES = {1: "Каморка", 2: "Квартира", 3: "Дом", 4: "Особняк"}

var house_tier = 1
var albums = {1: {}, 2: {}, 3: {}, 4: {}}
var coins = 0
var item_pity = 0
var key_pity = 0

func current_album() -> Dictionary:
    return albums[house_tier]

func get_variant(item: String) -> int:
    return current_album().get(item, -1)

func album_complete() -> bool:
    return current_album().size() >= ITEMS.size()

func add(item: String, variant: int):
    albums[house_tier][item] = variant
    persist()

func roll_win_reward() -> Dictionary:
    if album_complete() and house_tier < 4:
        key_pity += 1
        if randf() <= 0.25 + key_pity * 0.10:
            key_pity = 0
            house_tier += 1
            persist()
            return {"type": "key"}
        coins += 5
        persist()
        return {"type": "coins", "amount": 5}
    
    item_pity += 1
    if randf() <= 0.35 + item_pity * 0.05:
        item_pity = 0
        var item = ITEMS[randi() % ITEMS.size()]
        var variant = randi() % VARIANTS
        var is_dup = current_album().has(item)
        albums[house_tier][item] = variant
        if is_dup:
            coins += 2
        persist()
        return {"type": "item", "item": item, "variant": variant, "dup": is_dup}
    
    coins += 5
    persist()
    return {"type": "coins", "amount": 5}

func buy_missing(item: String) -> bool:
    if coins >= 50 and not current_album().has(item):
        coins -= 50
        albums[house_tier][item] = randi() % VARIANTS
        persist()
        return true
    return false

func persist():
    SaveSystem.save_game({
        "albums": albums,
        "tier": house_tier,
        "coins": coins,
        "level": GameManager.current_level
    })

func try_load_save():
    var d = SaveSystem.load_game()
    if d.has("albums"):
        albums = {}
        for k in d["albums"].keys():
            albums[int(k)] = d["albums"][k]
        for t in [1, 2, 3, 4]:
            if not albums.has(t):
                albums[t] = {}
    if d.has("tier"):
        house_tier = d["tier"]
    if d.has("coins"):
        coins = d["coins"]
    if d.has("level"):
        GameManager.current_level = d["level"]