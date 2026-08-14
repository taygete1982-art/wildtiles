extends Node2D

var tile_type: String = ""
var is_clicked: bool = false
var is_blocked: bool = false
var saved_position: Vector2 = Vector2.ZERO
var saved_z: int = 0

const ART_H = 86.0

func setup(type: String):
    tile_type = type
    var path = "res://assets/art/patient_" + type + ".png"
    if ResourceLoader.exists(path):
        var tex = load(path)
        var sprite = get_node("Art/Sprite")
        sprite.texture = tex
        var w = tex.get_width()
        var h = tex.get_height()
        sprite.region_enabled = true
        sprite.region_rect = Rect2(w * 0.28, h * 0.02, w * 0.44, h * 0.96)
        var s = ART_H / (h * 0.96)
        sprite.scale = Vector2(s, s)
    get_node("Art").rotation = randf_range(-0.03, 0.03)
    start_breathing()

func start_breathing():
    var art = get_node("Art")
    var t = create_tween().set_loops()
    t.tween_interval(randf() * 1.5)
    t.tween_property(art, "scale", Vector2(1.015, 1.015), 1.6).set_trans(Tween.TRANS_SINE)
    t.tween_property(art, "scale", Vector2(1.0, 1.0), 1.6).set_trans(Tween.TRANS_SINE)

func apply_layer(layer: int):
    var shadow = get_node("Shadow")
    shadow.position = Vector2(layer * 1.5, layer * 2.0)
    shadow.material = shadow.material.duplicate()
    shadow.material.set_shader_parameter("shadow_color", Color(0.05, 0.04, 0.06, 0.28 + layer * 0.06))

func _on_area_2d_input_event(_viewport, event, _shape_idx):
    if event is InputEventMouseButton and event.pressed:
        on_tile_clicked()

func on_tile_clicked():
    if is_blocked:
        return
    if not is_clicked:
        is_clicked = true
        hop()
        GameManager.on_tile_clicked(self)

func hop():
    var t = create_tween()
    t.tween_property(self, "position:y", position.y - 14, 0.09).set_trans(Tween.TRANS_SINE)
    t.tween_property(self, "position:y", position.y, 0.09).set_trans(Tween.TRANS_BOUNCE)

func set_blocked(blocked: bool):
    is_blocked = blocked
    var art = get_node("Art")
    if blocked:
        art.modulate = Color(0.55, 0.58, 0.68, 1)
    else:
        art.modulate = Color(1, 1, 1, 1)

func animate_removal():
    var art = get_node("Art")
    art.modulate = Color(2.0, 1.8, 1.2, 1)
    spawn_particles()
    var t = create_tween()
    t.tween_interval(0.12)
    t.tween_property(self, "scale", Vector2(0, 0), 0.18)
    t.tween_callback(queue_free)

func spawn_particles():
    var p = GPUParticles2D.new()
    p.amount = 14
    p.lifetime = 0.5
    p.one_shot = true
    p.emitting = true
    var m = ParticleProcessMaterial.new()
    m.direction = Vector3(0, -1, 0)
    m.spread = 180.0
    m.initial_velocity_min = 60.0
    m.initial_velocity_max = 150.0
    m.gravity = Vector3(0, 300, 0)
    m.color = Color(1.0, 0.85, 0.4, 1.0)
    p.process_material = m
    add_child(p)