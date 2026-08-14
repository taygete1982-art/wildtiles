extends Control

signal continue_pressed

const STORIES = {
    2: {"title": "Глава 2: Квартира", "text": "Ты теперь ординатор-практикант. Дежурства по ночам, но жильё — своё. Обживай."},
    3: {"title": "Глава 3: Дом", "text": "Ты фельдшер в деревне. Печь, веранда и приём по утрам. Дом стал больше."},
    4: {"title": "Глава 4: Особняк", "text": "Ты главврач. Кабинет, камин и картины. Ты прошёл путь от каморки до особняка."}
}

func show_story(tier: int):
    var s = STORIES.get(tier, STORIES[2])
    get_node("Title").text = s.title
    get_node("Text").text = s.text
    visible = true

func _on_continue_button_pressed():
    visible = false
    continue_pressed.emit()