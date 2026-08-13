extends Control

func _ready():
    CollectionManager.try_load_save()

func _on_play_button_pressed():
    get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_home_button_pressed():
    get_tree().change_scene_to_file("res://scenes/Home.tscn")

func _on_album_button_pressed():
    get_tree().change_scene_to_file("res://scenes/Album.tscn")