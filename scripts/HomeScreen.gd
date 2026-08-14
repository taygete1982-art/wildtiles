extends Control

const SLOTS = {
    "poster": Vector2(300, 260),
    "clock": Vector2(140, 300),
    "shelf": Vector2(520, 320),
    "plant": Vector2(660, 420),
    "lamp": Vector2(140, 560),
    "wardrobe": Vector2(580, 600),
    "nightstand": Vector2(60, 700),
    "desk": Vector2(380, 720),
    "bed": Vector2(200, 780),
    "fridge": Vector2(660, 780),
    "chair": Vector2(480, 850),
    "rug": Vector2(360, 960)
}

func _ready():
    build()

func build():
    get_node("CoinsLabel").text = "Монеты: " + str(CollectionManager.coins)
    get_node("HouseLabel").text = CollectionManager.HOUSE_NAMES[CollectionManager.house_tier] + "  " + str(CollectionManager.current_album().size()) + "/12"
    
    for item in SLOTS:
        var path = "res://assets/art/sticker_" + item + ".png"
        if not ResourceLoader.exists(path):
            continue
        var owned = CollectionManager.owns(item)
        
        var spr = Sprite2D.new()
        spr.texture = load(path)
        var s = 190.0 / max(spr.texture.get_width(), spr.texture.get_height())
        spr.scale = Vector2(s, s)
        spr.position = SLOTS[item]
        spr.rotation = randf_range(-0.04, 0.04)
        var mat = ShaderMaterial.new()
        mat.shader = load("res://shaders/variant.gdshader")
        if owned:
            mat.set_shader_parameter("silhouette", 0.0)
        else:
            mat.set_shader_parameter("silhouette", 1.0)
            mat.set_shader_parameter("silhouette_color", Color(0.1, 0.1, 0.12, 0.45))
        spr.material = mat
        add_child(spr)
        
        if not owned:
            var lock = Label.new()
            lock.text = "🔒"
            lock.position = SLOTS[item] + Vector2(-12, 60)
            add_child(lock)
    
    if CollectionManager.current_album().size() >= 3 and ResourceLoader.exists("res://assets/art/dog.png"):
        var d = Sprite2D.new()
        d.texture = load("res://assets/art/dog.png")
        var s = 160.0 / max(d.texture.get_width(), d.texture.get_height())
        d.scale = Vector2(s, s)
        d.position = Vector2(520, 980)
        add_child(d)

func _on_back_button_pressed():
    get_tree().change_scene_to_file("res://scenes/Main.tscn")