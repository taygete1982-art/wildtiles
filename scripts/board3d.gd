extends Node3D

var tiles: Array = []
var tile3d_script = preload("res://scripts/tile3d.gd")

func generate_level(level: int):
	clear_board()
	var config = LevelManager.get_level_config(level)
	var positions = generate_positions(config.tile_count, config.layers)
	var groups = build_groups(config.tile_count, config.types)
	
	var assignment = try_generate_solvable(positions, groups)
	if assignment.is_empty():
		assignment = fallback_assignment(positions, groups)
	
	for pos in positions:
		var body = StaticBody3D.new()
		body.set_script(tile3d_script)
		add_child(body)
		body.setup(assignment[pos.id])
		body.lx = pos.x
		body.ly = pos.y
		body.layer = pos.layer
		body.position = Vector3(pos.x / 100.0 - pos.layer * 0.06, pos.layer * 0.14, pos.y / 100.0)
		tiles.append(body)
	
	update_blocked()

func remaining() -> int:
	var n = 0
	for t in tiles:
		if not t.taken:
			n += 1
	return n

func take(t):
	t.taken = true
	t.visible = false

func restore(t):
	t.taken = false
	t.visible = true

func try_generate_solvable(positions: Array, groups: Array) -> Dictionary:
	for attempt in range(8):
		var avail = positions.duplicate(true)
		var seq = groups.duplicate()
		seq.shuffle()
		var assign = {}
		var ok = true
		
		while avail.size() > 0:
			var free = []
			for i in range(avail.size()):
				if is_free_pos(avail[i], avail):
					free.append(i)
			if free.size() < 3:
				ok = false
				break
			free.shuffle()
			var t = seq.pop_back()
			var picked = [free[0], free[1], free[2]]
			for pi in picked:
				assign[avail[pi].id] = t
			picked.sort()
			for k in range(picked.size() - 1, -1, -1):
				avail.remove_at(picked[k])
		if ok:
			return assign
	return {}

func fallback_assignment(positions: Array, groups: Array) -> Dictionary:
	var flat = []
	for g in groups:
		flat.append(g)
		flat.append(g)
		flat.append(g)
	flat.shuffle()
	var assign = {}
	for i in range(positions.size()):
		assign[positions[i].id] = flat[i]
	return assign

func is_free_pos(pos: Dictionary, avail: Array) -> bool:
	for other in avail:
		if other == pos:
			continue
		if other.layer > pos.layer:
			var dx = abs(other.x - pos.x)
			var dy = abs(other.y - pos.y)
			if dx < 85 and dy < 110:
				return false
	return true

func build_groups(count: int, num_types: int) -> Array:
	var types = get_tile_types(num_types)
	var groups = []
	var n = int(floorf(float(count) / 3.0))
	for g in range(n):
		groups.append(types[g % types.size()])
	return groups

func generate_positions(count: int, layers: int) -> Array:
	var positions = []
	var per_layer = int(floorf(float(count) / float(layers)))
	var extra = count - per_layer * layers
	var cols = 6
	var sx = 96
	var sy = 124
	var hx = 48
	var hy = 62
	var id = 0
	
	for layer in range(layers):
		var n = per_layer + (1 if layer < extra else 0)
		for i in range(n):
			var col = i % cols
			var row = int(floorf(float(i) / float(cols)))
			positions.append({
				"id": id,
				"x": col * sx + layer * hx - layer * 6,
				"y": row * sy + layer * hy,
				"layer": layer
			})
			id += 1
	return positions

func get_tile_types(count: int) -> Array:
	var p = CollectionManager.PATIENTS.duplicate()
	p.shuffle()
	return p.slice(0, count)

func clear_board():
	for t in tiles:
		t.queue_free()
	tiles.clear()

func is_tile_available(t) -> bool:
	for other in tiles:
		if other == t or other.taken:
			continue
		if other.layer > t.layer:
			var dx = abs(other.lx - t.lx)
			var dy = abs(other.ly - t.ly)
			if dx < 85 and dy < 110:
				return false
	return true

func update_blocked():
	for t in tiles:
		if not t.taken:
			t.set_blocked(not is_tile_available(t))

func get_hint():
	for t in tiles:
		if not t.taken and is_tile_available(t):
			return t
	return null

func shuffle_board():
	var active = []
	for t in tiles:
		if not t.taken:
			active.append(t)
	var types = []
	for t in active:
		types.append(t.tile_type)
	types.shuffle()
	for i in range(active.size()):
		active[i].set_type(types[i])
	update_blocked()
