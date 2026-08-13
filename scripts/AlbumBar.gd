extends Control

const ITEMS = ["chair", "sofa", "table", "bed", "lamp", "tv",
               "shelf", "plant", "clock", "fridge", "wardrobe", "sink"]
const SLOT_W = 52

func _ready():
    refresh()

func refresh():
    for c in get_children():
        if c.name != "Panel":
            c.queue_free()
    
    for i in range(ITEMS.size()):
        var item = ITEMS[i]
        var rect = TextureRect.new()
        var path = "res://assets/tiles/" + item + ".png"
        if ResourceLoader.exists(path):
            rect.texture = load(path)
        rect.name = "Slot_" + item
        rect.position = Vector2(8 + i * SLOT_W, 6)
        rect.size = Vector2(44, 44)
        rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
        
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