extends Control

const SLOTS = {
    "clock": Vector2(360, 260),
    "shelf": Vector2(560, 340),
    "lamp": Vector2(110, 560),
    "wardrobe": Vector2(580, 640),
    "tv": Vector2(360, 640),
    "sink": Vector2(90, 700),
    "bed": Vector2(180, 800),
    "fridge": Vector2(640, 820),
    "table": Vector2(360, 880),
    "chair": Vector2(470, 900),
    "sofa": Vector2(240, 940),
    "plant": Vector2(660, 940)
}

func _ready():
    build()

func build():
    get_node("Wall").material.set_shader_parameter("base", ThemeManager.get_wall())
    get_node("Floor").material.set_shader_parameter("base", ThemeManager.get_floorc())
    get_node("CoinsLabel").text = "Монеты: " + str(CollectionManager.coins)
    get_node("HouseLabel").text = CollectionManager.HOUSE_NAMES[CollectionManager.house_tier]
    
    for item in SLOTS:
        var path = "res://assets/tiles/" + item + ".png"
        if not ResourceLoader.exists(path):
            continue
        var v = CollectionManager.get_variant(item)
        
        if v >= 0:
            var sh = ColorRect.new()
            sh.size = Vector2(180, 26)
            sh.position = SLOTS[item] + Vector2(-90, 80)
            sh.color = Color(0, 0, 0, 0.25)
            sh.mouse_filter = Control.MOUSE_FILTER_IGNORE
            add_child(sh)
        
        var spr = Sprite2D.new()
        spr.texture = load(path)
        var s = 190.0 / max(spr.texture.get_width(), spr.texture.get_height())
        spr.scale = Vector2(s, s)
        spr.position = SLOTS[item]
        var mat = ShaderMaterial.new()
        mat.shader = load("res://shaders/variant.gdshader")
        if v >= 0:
            mat.set_shader_parameter("silhouette", 0.0)
            mat.set_shader_parameter("hue_shift", v * 0.25)
            mat.set_shader_parameter("saturation", ThemeManager.get_saturation())
        else:
            mat.set_shader_parameter("silhouette", 1.0)
            mat.set_shader_parameter("silhouette_color", Color(0.08, 0.08, 0.1, 0.35))
        spr.material = mat
        add_child(spr)
    
    if CollectionManager.current_album().size() >= 3 and ResourceLoader.exists("res://assets/tiles/dog.png"):
        var d = Sprite2D.new()
        d.texture = load("res://assets/tiles/dog.png")
        var s = 120.0 / max(d.texture.get_width(), d.texture.get_height())
        d.scale = Vector2(s, s)
        d.position = Vector2(560, 1000)
        add_child(d)

func _on_back_button_pressed():
    get_tree().change_scene_to_file("res://scenes/Main.tscn")