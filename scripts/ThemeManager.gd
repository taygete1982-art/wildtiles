extends Node

var chapters = {
    1: {"name":"Общага", "saturation":1.0, "bg_top":Color(0.38,0.10,0.16), "bg_bottom":Color(0.10,0.03,0.07), "glow":Color(1.0,0.55,0.25,0.3)},
    2: {"name":"Ординатура", "saturation":0.7, "bg_top":Color(0.10,0.30,0.28), "bg_bottom":Color(0.03,0.09,0.09), "glow":Color(0.4,0.9,0.7,0.25)},
    3: {"name":"Деревня", "saturation":0.5, "bg_top":Color(0.28,0.26,0.14), "bg_bottom":Color(0.08,0.07,0.04), "glow":Color(0.9,0.8,0.4,0.2)},
    4: {"name":"Главврач", "saturation":0.3, "bg_top":Color(0.22,0.20,0.32), "bg_bottom":Color(0.06,0.05,0.10), "glow":Color(0.6,0.6,0.9,0.2)}
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

func get_glow() -> Color:
    return get_config().glow