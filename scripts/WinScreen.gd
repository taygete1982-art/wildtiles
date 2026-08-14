extends Control

signal restart_requested
signal next_level_requested

func _on_next_level_button_pressed():
    next_level_requested.emit()

func _on_restart_button_pressed():
    restart_requested.emit()

func show_drop(item: String, caption: String):
    var icon = get_node("DropIcon")
    var label = get_node("DropLabel")
    var path = "res://assets/art/sticker_" + item + ".png"
    if ResourceLoader.exists(path):
        icon.texture = load(path)
    icon.material = null
    icon.visible = true
    label.text = caption + " [" + CollectionManager.ITEM_NAMES[item] + "]"

func show_coins(amount: int):
    get_node("DropIcon").visible = false
    get_node("DropLabel").text = "+" + str(amount) + " монет в копилку"

func show_key():
    get_node("DropIcon").visible = false
    get_node("DropLabel").text = "КЛЮЧ ОТ НОВОГО ЖИЛЬЯ! Переезд!"