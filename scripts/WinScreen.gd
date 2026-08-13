extends Control

signal restart_requested
signal next_level_requested

func _on_next_level_button_pressed():
    next_level_requested.emit()

func _on_restart_button_pressed():
    restart_requested.emit()

func show_drop(item: String, variant: int):
    var icon = get_node("DropIcon")
    var label = get_node("DropLabel")
    var path = "res://assets/tiles/" + item + ".png"
    if ResourceLoader.exists(path):
        icon.texture = load(path)
    var mat = ShaderMaterial.new()
    mat.shader = load("res://shaders/variant.gdshader")
    mat.set_shader_parameter("hue_shift", variant * 0.25)
    mat.set_shader_parameter("silhouette", 0.0)
    icon.material = mat
    icon.visible = true
    label.text = "Выпало: " + item + "!"

func show_no_drop():
    get_node("DropIcon").visible = false
    get_node("DropLabel").text = "В этот раз без дропа... Переиграй!"