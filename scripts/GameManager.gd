extends Node

var score: int = 0
var current_level: int = 1
var max_levels: int = 10
var is_game_over: bool = false

signal tile_clicked(tile)
signal level_completed
signal game_over

func start_game():
    score = 0
    current_level = 1
    is_game_over = false
    print("Игра началась!")

func on_tile_clicked(tile):
    print("GameManager received tile: ", tile.tile_type)
    tile_clicked.emit(tile)

func add_score(points: int):
    score += points
    print("Счёт: ", score)

func complete_level():
    if current_level < max_levels:
        current_level += 1
        level_completed.emit()
        print("Уровень ", current_level - 1, " пройден!")
    else:
        is_game_over = true
        game_over.emit()
        print("Игра пройдена!")

func fail_level():
    is_game_over = true
    game_over.emit()
    print("Уровень провален!")

func reset_game():
    score = 0
    current_level = 1
    is_game_over = false