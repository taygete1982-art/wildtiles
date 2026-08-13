extends Node
class_name HintSystem

var hint_uses: int = 3

func use_hint() -> bool:
    if hint_uses > 0:
        hint_uses -= 1
        return true
    return false

func reset_hints():
    hint_uses = 3
