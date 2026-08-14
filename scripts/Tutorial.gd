extends Control

signal done_pressed

func _on_done_button_pressed():
    SaveSystem.set_flag("tutorial_done", true)
    visible = false
    done_pressed.emit()