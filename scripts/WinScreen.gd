extends Control

signal restart_requested
signal next_level_requested

func _on_next_level_button_pressed():
    next_level_requested.emit()

func _on_restart_button_pressed():
    restart_requested.emit()

func show_drop(item: String, variant: int, is_new: bool):
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
    label.text = ("Новое: " if is_new else "Перекрас: ") + item + "!"

func show_coins(amount: int):
    get_node("DropIcon").visible = false
    get_node("DropLabel").text = "+" + str(amount) + " монет"

func show_key():
    get_node("DropIcon").visible = false
    get_node("DropLabel").text = "КЛЮЧ ОТ НОВОГО ЖИЛЬЯ! Переезд!"