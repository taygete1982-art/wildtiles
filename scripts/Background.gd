extends Control

func _ready():
    apply_theme()

func apply_theme():
    var rect = get_node("ColorRect")
    if rect.material:
        rect.material.set_shader_parameter("top_color", ThemeManager.get_bg_top())
        rect.material.set_shader_parameter("bottom_color", ThemeManager.get_bg_bottom())
        rect.material.set_shader_parameter("glow_color", ThemeManager.get_glow())