extends Control

const ITEMS = ["desk", "bed", "chair", "wardrobe", "lamp", "fridge",
               "shelf", "poster", "nightstand", "plant", "clock", "rug"]

func _ready():
    build()

func build():
    get_node("CoinsLabel").text = "Монеты: " + str(CollectionManager.coins)
    var grid = get_node("Grid")
    for c in grid.get_children():
        c.queue_free()
    
    for i in range(ITEMS.size()):
        var item = ITEMS[i]
        var col = i % 3
        var row = int(floorf(float(i) / 3.0))
        var x = 70 + col * 220
        var y = 140 + row * 260
        
        var rect = TextureRect.new()
        var path = "res://assets/art/sticker_" + item + ".png"
        if ResourceLoader.exists(path):
            rect.texture = load(path)
        rect.position = Vector2(x, y)
        rect.size = Vector2(160, 160)
        rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        
        var mat = ShaderMaterial.new()
        mat.shader = load("res://shaders/variant.gdshader")
        if CollectionManager.owns(item):
            mat.set_shader_parameter("silhouette", 0.0)
        else:
            mat.set_shader_parameter("silhouette", 1.0)
        rect.material = mat
        grid.add_child(rect)
        
        var label = Label.new()
        label.text = CollectionManager.ITEM_NAMES[item]
        label.position = Vector2(x + 40, y + 165)
        grid.add_child(label)
        
        if not CollectionManager.owns(item):
            var btn = Button.new()
            btn.text = "Купить 50"
            btn.position = Vector2(x + 30, y + 195)
            btn.size = Vector2(110, 40)
            btn.disabled = CollectionManager.coins < 50
            btn.pressed.connect(_buy.bind(item))
            grid.add_child(btn)

func _buy(item: String):
    if CollectionManager.buy_missing(item):
        build()

func _on_back_button_pressed():
    get_tree().change_scene_to_file("res://scenes/Main.tscn")