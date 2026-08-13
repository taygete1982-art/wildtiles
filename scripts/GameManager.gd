extends Node

var score: int = 0
var current_level: int = 1

func start_game():
    score = 0
    print("Игра началась!")

func add_score(points: int):
    score += points
    print("Счёт: ", score)
