extends Control

signal restart_requested

func _on_restart_button_pressed():
    restart_requested.emit()
