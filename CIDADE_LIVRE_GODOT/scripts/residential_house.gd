extends Node3D
class_name ResidentialHouse

var interior_root: Node3D
var exterior_root: Node3D
var occupied := false

func _ready() -> void:
	_build_exterior()
	_build_interior()

func _build_exterior() -> void:
	exterior_root = Node3D.new()
	exterior_root.name = "Exterior"
	add_child(exterior_root)
	_box(exterior_root, Vector3(0, 3.25, 0), Vector3(7.5, 0.5, 6.5), Color(0.28, 0.16, 0.12), false, "Roof")
	_box(exterior_root, Vector3(0, 1.0, -3.06), Vector3(7, 2, 0.18), Color(0.66, 0.55, 0.43), true, "RearWall")
	_box(exterior_root, Vector3(-3.56, 1.5, 0), Vector3(0.18, 3, 6), Color(0.66, 0.55, 0.43), true, "LeftWall")
	_box(exterior_root, Vector3(3.56, 1.5, 0), Vector3(0.18, 3, 6), Color(0.66, 0.55, 0.43), true, "RightWall")
	# Front wall is split to leave a real doorway.
	_box(exterior_root, Vector3(-2.25, 1.5, 3.06), Vector3(2.5, 3, 0.18), Color(0.66, 0.55, 0.43), true, "FrontLeft")
	_box(exterior_root, Vector3(2.25, 1.5, 3.06), Vector3(2.5, 3, 0.18), Color(0.66, 0.55, 0.43), true, "FrontRight")
	_box(exterior_root, Vector3(0, 2.65, 3.06), Vector3(2, 0.7, 0.18), Color(0.66, 0.55, 0.43), true, "DoorHeader")
	_box(exterior_root, Vector3(-2.0, 1.8, 3.18), Vector3(1.0, 1.0, 0.08), Color(0.22, 0.48, 0.68), false, "WindowLeft")
	_box(exterior_root, Vector3(2.0, 1.8, 3.18), Vector3(1.0, 1.0, 0.08), Color(0.22, 0.48, 0.68), false, "WindowRight")
	_box(exterior_root, Vector3(0, 1.1, 3.15), Vector3(1.5, 2.1, 0.12), Color(0.24, 0.12, 0.07), false, "Door")
	_box(exterior_root, Vector3(0, 0.08, 0), Vector3(7.2, 0.16, 6.2), Color(0.38, 0.34, 0.29), false, "Foundation")
	_box(exterior_root, Vector3(0, 0.16, 3.7), Vector3(2.2, 0.32, 1.1), Color(0.52, 0.48, 0.42), true, "FrontStep")
	_box(exterior_root, Vector3(-2.0, 1.8, 3.23), Vector3(1.16, 1.16, 0.12), Color(0.12, 0.12, 0.12), false, "LeftWindowFrame")
	_box(exterior_root, Vector3(2.0, 1.8, 3.23), Vector3(1.16, 1.16, 0.12), Color(0.12, 0.12, 0.12), false, "RightWindowFrame")

func _build_interior() -> void:
	interior_root = Node3D.new()
	interior_root.name = "Interior"
	interior_root.visible = false
	add_child(interior_root)
	_box(interior_root, Vector3(0, 0.0, 0), Vector3(6.7, 0.18, 5.7), Color(0.48, 0.34, 0.22), true, "WoodFloor")
	_box(interior_root, Vector3(0, 1.5, -2.85), Vector3(6.7, 3, 0.16), Color(0.88, 0.82, 0.68), true, "BackWall")
	_box(interior_root, Vector3(-2.25, 1.5, 2.85), Vector3(2.2, 3, 0.16), Color(0.88, 0.82, 0.68), true, "FrontLeftWall")
	_box(interior_root, Vector3(2.25, 1.5, 2.85), Vector3(2.2, 3, 0.16), Color(0.88, 0.82, 0.68), true, "FrontRightWall")
	_box(interior_root, Vector3(0, 2.65, 2.85), Vector3(2.3, 0.7, 0.16), Color(0.88, 0.82, 0.68), true, "FrontHeader")
	_box(interior_root, Vector3(-3.3, 1.5, 0), Vector3(0.16, 3, 5.7), Color(0.84, 0.78, 0.66), true, "LeftWall")
	_box(interior_root, Vector3(3.3, 1.5, 0), Vector3(0.16, 3, 5.7), Color(0.84, 0.78, 0.66), true, "RightWall")
	_box(interior_root, Vector3(0, 2.95, 0), Vector3(6.7, 0.16, 5.7), Color(0.92, 0.89, 0.8), true, "Ceiling")
	# Living room furniture and a compact kitchen.
	_box(interior_root, Vector3(-1.55, 0.48, -1.35), Vector3(2.4, 0.8, 0.9), Color(0.28, 0.19, 0.14), true, "Sofa")
	_box(interior_root, Vector3(-1.45, 0.28, 0.0), Vector3(1.5, 0.12, 0.8), Color(0.32, 0.22, 0.14), true, "CoffeeTable")
	_box(interior_root, Vector3(2.2, 0.5, -1.8), Vector3(1.2, 1.0, 0.65), Color(0.48, 0.48, 0.45), true, "KitchenCounter")
	_box(interior_root, Vector3(2.2, 1.15, -1.8), Vector3(1.2, 0.12, 0.65), Color(0.72, 0.72, 0.68), false, "CounterTop")
	_box(interior_root, Vector3(1.9, 0.45, 1.45), Vector3(1.4, 0.8, 1.8), Color(0.42, 0.25, 0.2), true, "Bed")
	_box(interior_root, Vector3(0, 2.7, 0), Vector3(0.35, 0.08, 0.35), Color(1.0, 0.86, 0.58), false, "CeilingLamp")
	var room_light := OmniLight3D.new()
	room_light.name = "InteriorLight"
	room_light.position = Vector3(0, 2.5, 0)
	room_light.light_color = Color(1.0, 0.82, 0.62)
	room_light.light_energy = 1.4
	room_light.omni_range = 9.0
	interior_root.add_child(room_light)

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
	if node_name == "CeilingLamp":
		material.emission_enabled = true
		material.emission = color
	mesh_instance.material_override = material
	body.add_child(mesh_instance)
	if solid:
		var collision := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = size
		collision.shape = shape
		body.add_child(collision)
	parent.add_child(body)

func interact(actor: Node3D) -> void:
	if actor == null:
		return
	occupied = not occupied
	exterior_root.visible = not occupied
	interior_root.visible = occupied
	actor.global_position = global_position + (Vector3(0, 1.0, 1.7) if occupied else Vector3(0, 1.0, 5.2))
