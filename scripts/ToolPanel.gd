extends Control

signal hint_requested
signal shuffle_requested
signal undo_requested

func _on_hint_button_pressed():
    hint_requested.emit()

func _on_shuffle_button_pressed():
    shuffle_requested.emit()

func _on_undo_button_pressed():
    undo_requested.emit()
