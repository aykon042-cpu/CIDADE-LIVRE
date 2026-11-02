extends VehicleBody3D
class_name CityVehicle

@export var engine_power := 180.0
@export var steering_limit := 0.48
@export var brake_force := 32.0
@export var handbrake_force := 65.0
var driver: Node3D
var vehicle_camera: Camera3D
var camera_target := Vector3(0, 3.0, 8.0)

func _ready() -> void:
	mass = 1250.0
	_build_placeholder_body()
	vehicle_camera = Camera3D.new()
	vehicle_camera.name = "VehicleCamera"
	vehicle_camera.position = camera_target
	vehicle_camera.rotation_degrees.x = -13.0
	vehicle_camera.current = false
	vehicle_camera.fov = 82.0
	add_child(vehicle_camera)
	for child in get_children():
		if child is VehicleWheel3D:
			child.use_as_traction = true
			child.wheel_friction_slip = 3.2
			child.suspension_stiffness = 28.0

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

func _physics_process(delta: float) -> void:
	if driver == null:
		engine_force = 0.0
		brake = 3.0
		return
	var throttle := Input.get_action_strength("move_forward") - Input.get_action_strength("move_back")
	var steer := Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	var speed_ratio := clampf(linear_velocity.length() / 24.0, 0.25, 1.0)
	engine_force = throttle * engine_power
	steering = move_toward(steering, steer * steering_limit * speed_ratio, delta * 2.8)
	brake = handbrake_force if Input.is_action_pressed("sprint") else (brake_force if absf(throttle) < 0.05 else 0.0)
	var desired_camera := Vector3(0, 2.8, 7.5 + linear_velocity.length() * 0.035)
	vehicle_camera.position = vehicle_camera.position.lerp(desired_camera, minf(1.0, delta * 3.0))
	vehicle_camera.look_at(global_position + global_basis.z * 2.0 + Vector3.UP, Vector3.UP)

func enter_vehicle(character: Node3D) -> void:
	if driver != null or character == null:
		return
	driver = character
	if character.has_method("set_vehicle_hidden"):
		character.set_vehicle_hidden(true)
	else:
		character.visible = false
		character.set_physics_process(false)
	vehicle_camera.current = true

func exit_vehicle() -> void:
	if driver == null:
		return
	var exit_position := global_position + global_basis.x * 2.2 + Vector3.UP * 0.8
	driver.global_position = exit_position
	if driver.has_method("set_vehicle_hidden"):
		driver.set_vehicle_hidden(false)
	else:
		driver.visible = true
		driver.set_physics_process(true)
	var pivot := driver.get_node_or_null("CameraPivot/Camera3D") as Camera3D
	if pivot != null:
		pivot.current = true
	driver = null
