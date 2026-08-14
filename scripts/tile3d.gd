extends StaticBody3D

var tile_type: String = ""
var is_blocked: bool = false
var taken: bool = false
var lx: float = 0.0
var ly: float = 0.0
var layer: int = 0
var box_mat: StandardMaterial3D
var face_mat: StandardMaterial3D

func setup(type: String):
    tile_type = type
    
    var box = MeshInstance3D.new()
    var bm = BoxMesh.new()
    bm.size = Vector3(0.92, 0.12, 1.16)
    box.mesh = bm
    box_mat = StandardMaterial3D.new()
    box_mat.albedo_color = Color(0.93, 0.90, 0.84)
    box.material_override = box_mat
    add_child(box)
    
    var face = MeshInstance3D.new()
    var pm = PlaneMesh.new()
    pm.size = Vector2(0.9, 1.14)
    face.mesh = pm
    face_mat = StandardMaterial3D.new()
    face_mat.cull_mode = StandardMaterial3D.CULL_DISABLED
    _apply_texture()
    face.material_override = face_mat
    face.rotation_degrees = Vector3(-90, 0, 0)
    face.position = Vector3(0, 0.065, 0)
    add_child(face)
    
    var cs = CollisionShape3D.new()
    var shp = BoxShape3D.new()
    shp.size = Vector3(0.92, 0.35, 1.16)
    cs.shape = shp
    add_child(cs)
    
    input_event.connect(_on_input)

func _apply_texture():
    var path = "res://assets/art/patient_" + tile_type + ".png"
    if ResourceLoader.exists(path):
        var tex = load(path)
        face_mat.albedo_texture = tex
        face_mat.uv1_scale = Vector3(0.44, 0.96, 1)
        face_mat.uv1_offset = Vector3(0.28, 0.02, 0)
        face_mat.emission_enabled = true
        face_mat.emission = Color(1, 1, 1)
        face_mat.emission_energy = 0.55
        face_mat.emission_texture = tex
    else:
        print("НЕТ ТЕКСТУРЫ: ", path)

func set_type(t: String):
    tile_type = t
    _apply_texture()
    set_blocked(is_blocked)

func _on_input(_cam, event, _pos, _normal, _shape):
    if event is InputEventMouseButton and event.pressed:
        if not is_blocked and not taken:
            GameManager.on_tile_clicked(self)

func set_blocked(b: bool):
    is_blocked = b
    if b:
        face_mat.albedo_color = Color(0.55, 0.58, 0.68)
        face_mat.emission_energy = 0.2
        box_mat.albedo_color = Color(0.45, 0.45, 0.5)
    else:
        face_mat.albedo_color = Color(1, 1, 1)
        face_mat.emission_energy = 0.55
        box_mat.albedo_color = Color(0.93, 0.90, 0.84)