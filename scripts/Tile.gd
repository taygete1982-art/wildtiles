extends Node2D

var tile_type: String = ""
var is_clicked: bool = false
var is_blocked: bool = false

func setup(type: String):
    tile_type = type
    var path = "res://assets/tiles/" + type + ".png"
    if ResourceLoader.exists(path):
        var tex = load(path)
        var sprite = get_node("Sprite")
        sprite.texture = tex
        var s = 48.0 / max(tex.get_width(), tex.get_height())
        sprite.scale = Vector2(s, s)
    else:
        print("Нет картинки: ", path)

func _on_area_2d_input_event(viewport, event, shape_idx):
    if event is InputEventMouseButton and event.pressed:
        on_tile_clicked()

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