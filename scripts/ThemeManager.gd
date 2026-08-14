extends Node

var chapters = {
    1: {"name":"Каморка", "saturation":1.0, "bg_top":Color(0.38,0.10,0.16), "bg_bottom":Color(0.10,0.03,0.07), "glow":Color(1.0,0.55,0.25,0.3), "wall":Color(0.55,0.38,0.36), "floorc":Color(0.40,0.28,0.20)},
    2: {"name":"Квартира", "saturation":0.7, "bg_top":Color(0.10,0.30,0.28), "bg_bottom":Color(0.03,0.09,0.09), "glow":Color(0.4,0.9,0.7,0.25), "wall":Color(0.40,0.50,0.48), "floorc":Color(0.45,0.35,0.25)},
    3: {"name":"Дом", "saturation":0.5, "bg_top":Color(0.28,0.26,0.14), "bg_bottom":Color(0.08,0.07,0.04), "glow":Color(0.9,0.8,0.4,0.2), "wall":Color(0.50,0.48,0.38), "floorc":Color(0.42,0.32,0.22)},
    4: {"name":"Особняк", "saturation":0.3, "bg_top":Color(0.22,0.20,0.32), "bg_bottom":Color(0.06,0.05,0.10), "glow":Color(0.6,0.6,0.9,0.2), "wall":Color(0.48,0.46,0.55), "floorc":Color(0.35,0.30,0.28)}
}

var current_chapter = 1

func _ready():
    call_deferred("apply_root_theme")

func apply_root_theme():
    var t = Theme.new()
    
    var sb = StyleBoxFlat.new()
    sb.bg_color = Color(0.98, 0.75, 0.30)
    sb.set_corner_radius_all(14)
    sb.border_width_bottom = 4
    sb.border_color = Color(0.75, 0.5, 0.15)
    var sbp = sb.duplicate()
    sbp.bg_color = Color(0.85, 0.6, 0.2)
    var sbh = sb.duplicate()
    sbh.bg_color = Color(1.0, 0.82, 0.4)
    t.set_stylebox("normal", "Button", sb)
    t.set_stylebox("pressed", "Button", sbp)
    t.set_stylebox("hover", "Button", sbh)
    t.set_color("font_color", "Button", Color(0.15, 0.1, 0.05))
    t.set_font_size("font_size", "Button", 24)
    t.set_font_size("font_size", "Label", 22)
    t.set_color("font_color", "Label", Color(0.95, 0.93, 0.88))
    
    get_tree().root.theme = t

func set_chapter(chapter: int):
    current_chapter = chapter

func get_config() -> Dictionary:
    return chapters.get(current_chapter, chapters[1])

func get_saturation() -> float:
    return get_config().saturation

func get_bg_top() -> Color:
    return get_config().bg_top

func get_bg_bottom() -> Color:
    return get_config().bg_bottom

func get_glow() -> Color:
    return get_config().glow

func get_wall() -> Color:
    return get_config().wall

func get_floorc() -> Color:
    return get_config().floorc