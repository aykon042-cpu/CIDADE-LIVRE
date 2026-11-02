extends CharacterBody3D
class_name CityPlayer

@export var walk_speed := 5.0
@export var sprint_speed := 8.0
@export var jump_velocity := 4.5
@export var mouse_sensitivity := 0.002
@export var touch_sensitivity := 0.004
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var camera_pivot: Node3D
var camera: Camera3D
var health := 100.0

func _ready() -> void:
	_build_body()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if not OS.has_feature("mobile") else Input.MOUSE_MODE_VISIBLE

func _build_body() -> void:
	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.42
	capsule.height = 1.8
	collision.shape = capsule
	collision.position.y = 0.9
	add_child(collision)
	var mesh := MeshInstance3D.new()
	var body_mesh := CapsuleMesh.new()
	body_mesh.radius = 0.42
	body_mesh.height = 1.8
	mesh.mesh = body_mesh
	mesh.position.y = 0.9
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.12, 0.32, 0.78)
	mesh.material_override = material
	add_child(mesh)
	camera_pivot = Node3D.new()
	camera_pivot.name = "CameraPivot"
	camera_pivot.position.y = 1.55
	add_child(camera_pivot)
	camera = Camera3D.new()
	camera.name = "Camera3D"
	camera.position = Vector3(0, 1.1, 5.5)
	camera.rotation.x = deg_to_rad(-12)
	camera.current = true
	camera_pivot.add_child(camera)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_rotate_camera(event.relative, mouse_sensitivity)
	elif event is InputEventScreenDrag and OS.has_feature("mobile"):
		var viewport_size := get_viewport().get_visible_rect().size
		# Reserve the left half for movement and the lower-right corner for action buttons.
		if event.position.x >= viewport_size.x * 0.45 and event.position.y <= viewport_size.y * 0.72:
			_rotate_camera(event.relative, touch_sensitivity)
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _rotate_camera(relative_motion: Vector2, sensitivity: float) -> void:
	camera_pivot.rotate_y(-relative_motion.x * sensitivity)
	camera.rotate_x(-relative_motion.y * sensitivity)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-55), deg_to_rad(35))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (camera_pivot.global_basis * Vector3(input.x, 0, input.y)).normalized()
	var speed := sprint_speed if Input.is_action_pressed("sprint") else walk_speed
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * 10.0)
	else:
		velocity.x = move_toward(velocity.x, 0.0, walk_speed * 5.0 * delta)
		velocity.z = move_toward(velocity.z, 0.0, walk_speed * 5.0 * delta)
	move_and_slide()

func take_damage(amount: float) -> void:
	health = maxf(health - amount, 0.0)
