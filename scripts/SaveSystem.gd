extends Node

const SAVE_PATH = "user://save_data.json"

func save_game(data: Dictionary):
    var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file:
        file.store_string(JSON.stringify(data))

func load_game() -> Dictionary:
    if not FileAccess.file_exists(SAVE_PATH):
        return {}
    
    var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file:
        var content = file.get_as_text()
        var json = JSON.parse_string(content)
        if json is Dictionary:
            return json
    return {}

func save_progress(level: int, score: int):
    var data = load_game()
    data["level"] = level
    data["score"] = score
    data["timestamp"] = Time.get_datetime_string_from_system()
    save_game(data)