extends Node

const PATIENTS = ["lion", "zebra", "giraffe", "hippo", "meerkat", "owl",
                  "croc", "frog", "monkey", "turtle", "hedgehog", "cat"]
const ITEMS = ["desk", "bed", "chair", "wardrobe", "lamp", "fridge",
               "shelf", "poster", "nightstand", "plant", "clock", "rug"]
const HOUSE_NAMES = {1: "Каморка", 2: "Квартира", 3: "Дом", 4: "Особняк"}
const ITEM_NAMES = {
    "desk": "Стол", "bed": "Кровать", "chair": "Стул", "wardrobe": "Шкаф",
    "lamp": "Торшер", "fridge": "Холодильник", "shelf": "Полка", "poster": "Постер",
    "nightstand": "Тумбочка", "plant": "Алоэ", "clock": "Будильник", "rug": "Коврик"
}
const CAPTIONS = [
    "Сосед съехал — теперь твоё!",
    "Урвал на барахолке. Пахнет бабушкой, зато крепкое.",
    "Бабушка прислала денег — хватило ровно на это.",
    "Нашёл у общаги. Отстирал — как новое.",
    "Выменял у коменданта на дежурство.",
    "Досталось по распределению. Не спрашивай."
]

var house_tier = 1
var albums = {1: {}, 2: {}, 3: {}, 4: {}}
var coins = 0
var item_pity = 0
var key_pity = 0

func current_album() -> Dictionary:
    return albums[house_tier]

func owns(item: String) -> bool:
    return current_album().has(item)

func album_complete() -> bool:
    return current_album().size() >= ITEMS.size()

func add(item: String):
    albums[house_tier][item] = true
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
        if owns(item):
            coins += 2
            persist()
            return {"type": "coins", "amount": 2}
        add(item)
        var caption = CAPTIONS[randi() % CAPTIONS.size()]
        return {"type": "item", "item": item, "caption": caption}
    
    coins += 5
    persist()
    return {"type": "coins", "amount": 5}

func buy_missing(item: String) -> bool:
    if coins >= 50 and not owns(item):
        coins -= 50
        albums[house_tier][item] = true
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
            var inner = {}
            for it in d["albums"][k].keys():
                inner[it] = true
            albums[int(k)] = inner
        for t in [1, 2, 3, 4]:
            if not albums.has(t):
                albums[t] = {}
    if d.has("tier"):
        house_tier = d["tier"]
    if d.has("coins"):
        coins = d["coins"]
    if d.has("level"):
        GameManager.current_level = d["level"]