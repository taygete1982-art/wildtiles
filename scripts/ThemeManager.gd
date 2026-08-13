extends Node

# Яркость: глава1=100%, глава2=70%, глава3=50%, глава4=30%
var chapters = {
    1: {"name":"Общага", "saturation":1.0, "bg_top":Color(1.0,0.80,0.35), "bg_bottom":Color(0.98,0.55,0.30)},
    2: {"name":"Ординатура", "saturation":0.7, "bg_top":Color(0.85,0.88,0.70), "bg_bottom":Color(0.70,0.78,0.60)},
    3: {"name":"Деревня", "saturation":0.5, "bg_top":Color(0.80,0.84,0.80), "bg_bottom":Color(0.62,0.70,0.64)},
    4: {"name":"Главврач", "saturation":0.3, "bg_top":Color(0.82,0.82,0.86), "bg_bottom":Color(0.66,0.66,0.72)}
}

var current_chapter = 1

func set_chapter_from_level(level: int):
    if level <= 3:
        current_chapter = 1
    elif level <= 6:
        current_chapter = 2
    elif level <= 8:
        current_chapter = 3
    else:
        current_chapter = 4

func get_config() -> Dictionary:
    return chapters.get(current_chapter, chapters[1])

func get_saturation() -> float:
    return get_config().saturation

func get_bg_top() -> Color:
    return get_config().bg_top

func get_bg_bottom() -> Color:
    return get_config().bg_bottom