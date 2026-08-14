extends Control

signal resume_pressed
signal restart_pressed
signal menu_pressed

func _on_resume_button_pressed():
    visible = false
    resume_pressed.emit()

func _on_restart_button_pressed():
    visible = false
    restart_pressed.emit()

func _on_menu_button_pressed():
    menu_pressed.emit()