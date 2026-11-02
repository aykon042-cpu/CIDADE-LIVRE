extends Node3D
class_name CityShop

var shop_name := "Mercado"
var service_price := 50
var service_amount := 35.0
var accent_color := Color(0.2, 0.55, 0.8)
var occupied := false
var exterior_root: Node3D
var interior_root: Node3D

func _ready() -> void:
	_build_exterior()
	_build_interior()
	_set_collision_enabled(interior_root, false)

func _build_exterior() -> void:
	exterior_root = Node3D.new()
	exterior_root.name = "Exterior"
	add_child(exterior_root)
	_box(exterior_root, Vector3(0, 2.1, -3.12), Vector3(7.5, 4.2, 0.16), Color(0.72, 0.7, 0.62), true, "BackWall")
	_box(exterior_root, Vector3(-3.67, 2.1, 0), Vector3(0.16, 4.2, 6.2), Color(0.72, 0.7, 0.62), true, "LeftWall")
	_box(exterior_root, Vector3(3.67, 2.1, 0), Vector3(0.16, 4.2, 6.2), Color(0.72, 0.7, 0.62), true, "RightWall")
	_box(exterior_root, Vector3(-2.35, 2.1, 3.12), Vector3(2.8, 4.2, 0.16), Color(0.72, 0.7, 0.62), true, "FrontLeft")
	_box(exterior_root, Vector3(2.35, 2.1, 3.12), Vector3(2.8, 4.2, 0.16), Color(0.72, 0.7, 0.62), true, "FrontRight")
	_box(exterior_root, Vector3(0, 3.9, 3.12), Vector3(2.0, 0.6, 0.16), Color(0.72, 0.7, 0.62), true, "DoorHeader")
	_box(exterior_root, Vector3(0, 1.45, 3.28), Vector3(2.3, 2.8, 0.16), accent_color, false, "Shopfront")
	_box(exterior_root, Vector3(0, 3.55, 3.34), Vector3(5.5, 0.65, 0.2), accent_color.darkened(0.25), false, "Sign")
	_box(exterior_root, Vector3(0, 0.12, 0), Vector3(7.8, 0.24, 6.8), Color(0.3, 0.3, 0.3), false, "Foundation")

func _build_interior() -> void:
	interior_root = Node3D.new()
	interior_root.name = "Interior"
	interior_root.visible = false
	add_child(interior_root)
	_box(interior_root, Vector3(0, 0, 0), Vector3(6.8, 0.18, 5.8), Color(0.55, 0.43, 0.3), true, "Floor")
	_box(interior_root, Vector3(0, 1.5, -2.85), Vector3(6.8, 3, 0.16), Color(0.82, 0.8, 0.72), true, "BackWall")
	_box(interior_root, Vector3(-3.35, 1.5, 0), Vector3(0.16, 3, 5.8), Color(0.82, 0.8, 0.72), true, "LeftWall")
	_box(interior_root, Vector3(3.35, 1.5, 0), Vector3(0.16, 3, 5.8), Color(0.82, 0.8, 0.72), true, "RightWall")
	_box(interior_root, Vector3(-1.4, 0.55, -1.7), Vector3(3.4, 1.1, 0.8), accent_color.darkened(0.2), true, "ServiceCounter")
	_box(interior_root, Vector3(1.9, 0.65, -1.8), Vector3(1.2, 1.3, 1.0), Color(0.65, 0.62, 0.52), true, "Shelf")
	var light := OmniLight3D.new()
	light.position = Vector3(0, 2.6, 0)
	light.light_color = Color(1.0, 0.88, 0.68)
	light.light_energy = 1.2
	light.omni_range = 8.0
	interior_root.add_child(light)

func _box(parent: Node3D, pos: Vector3, size: Vector3, color: Color, solid: bool, node_name: String) -> void:
	var body := StaticBody3D.new() if solid else Node3D.new()
	body.name = node_name
	body.position = pos
	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	mesh_instance.material_override = material
	body.add_child(mesh_instance)
	if solid:
		var collision := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = size
		collision.shape = shape
		body.add_child(collision)
	parent.add_child(body)

func _set_collision_enabled(root: Node, enabled: bool) -> void:
	for child in root.get_children():
		if child is CollisionShape3D:
			child.set_deferred("disabled", not enabled)
		_set_collision_enabled(child, enabled)

func interact(actor: Node3D, economy: Node) -> String:
	if actor == null or economy == null:
		return ""
	if not occupied:
		occupied = true
		exterior_root.visible = false
		interior_root.visible = true
		_set_collision_enabled(exterior_root, false)
		_set_collision_enabled(interior_root, true)
		actor.global_position = global_position + Vector3(0, 1.0, 1.5)
		return "%s: E para comprar recuperação ($%d)" % [shop_name, service_price]
	var result := ""
	if int(economy.get("money")) < service_price:
		result = "%s: dinheiro insuficiente ($%d)" % [shop_name, service_price]
	else:
		var current_health := float(actor.get("health"))
		var new_health := minf(current_health + service_amount, 100.0)
		if is_equal_approx(current_health, new_health):
			result = "%s: sua saúde já está cheia" % shop_name
		else:
			economy.set("money", int(economy.get("money")) - service_price)
			actor.set("health", new_health)
			result = "%s: recuperação comprada!" % shop_name
	occupied = false
	exterior_root.visible = true
	interior_root.visible = false
	_set_collision_enabled(exterior_root, true)
	_set_collision_enabled(interior_root, false)
	actor.global_position = global_position + Vector3(0, 1.0, 5.2)
	return result
