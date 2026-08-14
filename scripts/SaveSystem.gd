extends Node

const SAVE_PATH = "user://save_data.json"
const FLAGS_PATH = "user://flags.json"

func save_game(data: Dictionary):
    var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file:
        file.store_string(JSON.stringify(data))

func load_game() -> Dictionary:
    if not FileAccess.file_exists(SAVE_PATH):
        return {}
    var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file:
        var json = JSON.parse_string(file.get_as_text())
        if json is Dictionary:
            return json
    return {}

func get_flags() -> Dictionary:
    if not FileAccess.file_exists(FLAGS_PATH):
        return {}
    var file = FileAccess.open(FLAGS_PATH, FileAccess.READ)
    if file:
        var json = JSON.parse_string(file.get_as_text())
        if json is Dictionary:
            return json
    return {}

func set_flag(key: String, value):
    var f = get_flags()
    f[key] = value
    var file = FileAccess.open(FLAGS_PATH, FileAccess.WRITE)
    if file:
        file.store_string(JSON.stringify(f))