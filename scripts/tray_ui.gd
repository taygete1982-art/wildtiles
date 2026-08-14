extends Control

const MAX_SLOTS: int = 7
var entries: Array = []

func add_entry(type: String, tile) -> bool:
    if entries.size() >= MAX_SLOTS:
        return false
    entries.append({"type": type, "tile": tile})
    _redraw()
    _check()
    return true

func _check():
    var counts = {}
    for e in entries:
        counts[e.type] = counts.get(e.type, 0) + 1
    for t in counts:
        if counts[t] >= 3:
            var removed = []
            for e in entries:
                if e.type == t:
                    removed.append(e)
            for e in removed:
                entries.erase(e)
                if is_instance_valid(e.tile):
                    e.tile.queue_free()
            GameManager.add_score(10)
            _redraw()

func undo_entry():
    if entries.size() > 0:
        var e = entries.pop_back()
        _redraw()
        update_warning()
        return e.tile
    return null

func make_icon(t: String):
    var path = "res://assets/art/patient_" + t + ".png"
    if not ResourceLoader.exists(path):
        return null
    var base = load(path)
    var at = AtlasTexture.new()
    at.atlas = base
    at.region = Rect2(base.get_width() * 0.28, base.get_height() * 0.02, base.get_width() * 0.44, base.get_height() * 0.96)
    return at

func _redraw():
    for c in get_children():
        if c.name.begins_with("Slot"):
            c.queue_free()
    for i in range(entries.size()):
        var trect = TextureRect.new()
        trect.name = "Slot" + str(i)
        trect.texture = make_icon(entries[i].type)
        trect.position = Vector2(10 + i * 70, 5)
        trect.size = Vector2(60, 80)
        trect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        trect.mouse_filter = Control.MOUSE_FILTER_IGNORE
        add_child(trect)
    update_warning()

func update_warning():
    var bg = get_node("Background")
    if entries.size() >= MAX_SLOTS - 1:
        bg.color = Color(0.55, 0.12, 0.12, 1)
    else:
        bg.color = Color(0.15, 0.12, 0.10, 0.9)

func clear_all():
    entries = []
    _redraw()