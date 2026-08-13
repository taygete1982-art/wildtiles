extends Control

const SLOTS = {
    "bed": Vector2(170, 640),
    "wardrobe": Vector2(560, 560),
    "shelf": Vector2(560, 300),
    "tv": Vector2(360, 560),
    "table": Vector2(360, 760),
    "chair": Vector2(470, 780),
    "lamp": Vector2(110, 420),
    "plant": Vector2(640, 800),
    "clock": Vector2(360, 220),
    "fridge": Vector2(90, 780),
    "sink": Vector2(90, 560),
    "sofa": Vector2(250, 860)
}

func _ready():
    build()

func build():
    for item in SLOTS:
        var path = "res://assets/tiles/" + item + ".png"
        if not ResourceLoader.exists(path):
            continue
        var spr = Sprite2D.new()
        spr.texture = load(path)
        var s = 200.0 / max(spr.texture.get_width(), spr.texture.get_height())
        spr.scale = Vector2(s, s)
        spr.position = SLOTS[item]
        var mat = ShaderMaterial.new()
        mat.shader = load("res://shaders/variant.gdshader")
        var v = CollectionManager.get_variant(item)
        if v >= 0:
            mat.set_shader_parameter("silhouette", 0.0)
            mat.set_shader_parameter("hue_shift", v * 0.25)
            mat.set_shader_parameter("saturation", ThemeManager.get_saturation())
        else:
            mat.set_shader_parameter("silhouette", 1.0)
            mat.set_shader_parameter("silhouette_color", Color(0.1, 0.1, 0.12, 0.3))
        spr.material = mat
        add_child(spr)

func _on_back_button_pressed():
    get_tree().change_scene_to_file("res://scenes/Main.tscn")