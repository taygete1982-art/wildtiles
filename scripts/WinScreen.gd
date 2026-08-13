extends Control

signal restart_requested
signal next_level_requested

func _on_next_level_button_pressed():
    next_level_requested.emit()

func _on_restart_button_pressed():
    restart_requested.emit()
