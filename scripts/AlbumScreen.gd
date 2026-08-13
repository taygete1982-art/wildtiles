extends Control

const ITEMS = ["chair", "sofa", "table", "bed", "lamp", "tv",
               "shelf", "plant", "clock", "fridge", "wardrobe", "sink"]

func _ready():
    build()

func build():
    for i in range(ITEMS.size()):
        var item = ITEMS[i]
        var col = i % 3
        var row = int(floorf(float(i) / 3.0))
        var x = 70 + col * 220
        var y = 140 + row * 260
        
        var rect = TextureRect.new()
        var path = "res://assets/tiles/" + item + ".png"
        if ResourceLoader.exists(path):
            rect.texture = load(path)
        rect.position = Vector2(x, y)
        rect.size = Vector2(160, 160)
        rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        
        var mat = ShaderMaterial.new()
        mat.shader = load("res://shaders/variant.gdshader")
        var v = CollectionManager.get_variant(item)
        if v >= 0:
            mat.set_shader_parameter("silhouette", 0.0)
            mat.set_shader_parameter("hue_shift", v * 0.25)
        else:
            mat.set_shader_parameter("silhouette", 1.0)
        rect.material = mat
        add_child(rect)
        
        var label = Label.new()
        label.text = item + (" ✓" if v >= 0 else "")
        label.position = Vector2(x + 30, y + 165)
        add_child(label)

func _on_back_button_pressed():
    get_tree().change_scene_to_file("res://scenes/Main.tscn")