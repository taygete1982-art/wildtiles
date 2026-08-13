extends Node2D

var tile_type: String = ""
var is_selected: bool = false
var is_clicked: bool = false
var is_blocked: bool = false

const TILE_COLORS = {
    "giraffe": Color(1.0, 0.8, 0.4, 1),
    "lion": Color(0.9, 0.6, 0.2, 1),
    "zebra": Color(0.9, 0.9, 0.9, 1),
    "meerkat": Color(0.8, 0.5, 0.3, 1),
    "acacia": Color(0.4, 0.7, 0.3, 1),
    "sloth": Color(0.6, 0.5, 0.4, 1),
    "tiger": Color(1.0, 0.5, 0.1, 1),
    "chameleon": Color(0.3, 0.8, 0.5, 1),
    "monstera": Color(0.2, 0.7, 0.4, 1),
    "camel": Color(0.9, 0.8, 0.5, 1),
    "fennec": Color(0.9, 0.7, 0.6, 1),
    "cactus": Color(0.5, 0.8, 0.4, 1)
}

func setup(type: String):
    tile_type = type
    print("Setting up tile: ", type)
    
    # Устанавливаем цвет
    var color = TILE_COLORS.get(type, Color(0.8, 0.8, 0.8, 1))
    get_node("Background").color = color
    
    # Устанавливаем текст
    get_node("Label").text = type.substr(0, 2).to_upper()

func _input_event(viewport, event, shape_idx):
    if event is InputEventMouseButton and event.pressed:
        print("Tile clicked: ", tile_type)
        on_tile_clicked()

func _on_area_2d_input_event(viewport, event, shape_idx):
    _input_event(viewport, event, shape_idx)

func on_tile_clicked():
    if is_blocked:
        print("Плитка заблокирована!")
        return
    
    if not is_clicked:
        is_clicked = true
        animate_click()
        GameManager.on_tile_clicked(self)

func animate_click():
    var tween = create_tween()
    tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
    tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)

func animate_hint():
    var tween = create_tween()
    tween.tween_property(self, "modulate", Color(1, 1, 0, 1), 0.2)
    tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2)
    tween.tween_property(self, "modulate", Color(1, 1, 0, 1), 0.2)
    tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2)

func set_blocked(blocked: bool):
    is_blocked = blocked
    if blocked:
        modulate = Color(0.5, 0.5, 0.5, 0.7)
    else:
        modulate = Color(1, 1, 1, 1)

func animate_removal():
    var tween = create_tween()
    tween.tween_property(self, "scale", Vector2(0, 0), 0.2)
    tween.tween_callback(queue_free)