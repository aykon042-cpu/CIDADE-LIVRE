extends VehicleBody3D
class_name CityVehicle

@export var engine_power := 110.0
@export var steering_limit := 0.45
@export var brake_force := 25.0
var driver: Node3D
var vehicle_camera: Camera3D

func _ready() -> void:
	mass = 1200.0
	_build_placeholder_body()
	vehicle_camera = Camera3D.new()
	vehicle_camera.name = "VehicleCamera"
	vehicle_camera.position = Vector3(0, 2.8, 7.0)
	vehicle_camera.rotation_degrees.x = -12.0
	vehicle_camera.current = false
	add_child(vehicle_camera)
	for child in get_children():
		if child is VehicleWheel3D:
			child.use_as_traction = true
			child.wheel_friction_slip = 2.5

func _build_placeholder_body() -> void:
	if get_node_or_null("CollisionShape3D") == null:
		var shape := CollisionShape3D.new()
		var box := BoxShape3D.new()
		box.size = Vector3(1.8, 0.8, 3.6)
		shape.shape = box
		shape.position.y = 0.65
		add_child(shape)
	if get_node_or_null("Visual") == null:
		var visual := MeshInstance3D.new()
		var mesh := BoxMesh.new()
		mesh.size = Vector3(1.8, 0.8, 3.6)
		visual.mesh = mesh
		visual.position.y = 0.65
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(0.72, 0.12, 0.08)
		visual.material_override = mat
		visual.name = "Visual"
		add_child(visual)

func _physics_process(_delta: float) -> void:
	if driver == null:
		engine_force = 0.0
		brake = 2.0
		return
	var throttle := Input.get_action_strength("move_forward") - Input.get_action_strength("move_back")
	var steer := Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	engine_force = throttle * engine_power
	steering = clampf(steer * steering_limit, -steering_limit, steering_limit)
	brake = brake_force if Input.is_action_pressed("sprint") else 0.0

func enter_vehicle(character: Node3D) -> void:
	driver = character
	character.visible = false
	character.set_physics_process(false)
	vehicle_camera.current = true
	character.global_position = global_position + Vector3.UP * 1.5

func exit_vehicle() -> void:
	if driver == null:
		return
	driver.global_position = global_position + global_basis.x * 2.0 + Vector3.UP
	driver.visible = true
	driver.set_physics_process(true)
	var pivot := driver.get_node_or_null("CameraPivot/Camera3D") as Camera3D
	if pivot != null:
		pivot.current = true
	driver = null
