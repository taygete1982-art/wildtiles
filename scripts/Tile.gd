extends Node2D

var tile_type: String = ""
var is_clicked: bool = false
var is_blocked: bool = false

const CARD_COLORS = {
	"chair": Color(0.95, 0.65, 0.35),
	"sofa": Color(0.90, 0.45, 0.45),
	"table": Color(0.80, 0.60, 0.40),
	"bed": Color(0.60, 0.55, 0.85),
	"lamp": Color(0.95, 0.80, 0.40),
	"tv": Color(0.45, 0.55, 0.75),
	"shelf": Color(0.70, 0.50, 0.35),
	"plant": Color(0.45, 0.80, 0.45),
	"clock": Color(0.85, 0.75, 0.60),
	"fridge": Color(0.60, 0.80, 0.85),
	"wardrobe": Color(0.75, 0.60, 0.50),
	"sink": Color(0.65, 0.80, 0.90)
}

func setup(type: String):
	tile_type = type
	var parts = type.split(":")
	var item = parts[0]
	var variant = 0
	if parts.size() > 1:
		variant = int(parts[1])
	var hue = float(variant) * 0.25
	var base = CARD_COLORS.get(item, Color(0.9, 0.9, 0.9))
	
	var card = get_node("Card")
	card.material = card.material.duplicate()
	card.material.set_shader_parameter("base_color", base)
	card.material.set_shader_parameter("hue_shift", hue)
	card.material.set_shader_parameter("saturation", ThemeManager.get_saturation())
	
	var glow = get_node("Shadow")
	glow.material = glow.material.duplicate()
	var gc = Color.from_hsv(fmod(base.h + hue, 1.0), base.s, base.v, 0.45)
	glow.material.set_shader_parameter("shadow_color", gc)
	
	var path = "res://assets/tiles/" + item + ".png"
	if ResourceLoader.exists(path):
		var tex = load(path)
		var sprite = get_node("Sprite")
		sprite.texture = tex
		var s = 44.0 / max(tex.get_width(), tex.get_height())
		sprite.scale = Vector2(s, s)
		sprite.material = sprite.material.duplicate()
		sprite.material.set_shader_parameter("hue_shift", hue)
		sprite.material.set_shader_parameter("saturation", ThemeManager.get_saturation())
		sprite.material.set_shader_parameter("silhouette", 0.0)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		on_tile_clicked()

func on_tile_clicked():
	if is_blocked:
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
