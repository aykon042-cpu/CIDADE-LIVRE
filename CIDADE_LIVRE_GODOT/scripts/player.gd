extends CharacterBody3D
class_name CityPlayer

@export var walk_speed := 5.5
@export var sprint_speed := 9.0
@export var acceleration := 22.0
@export var air_control := 0.45
@export var jump_velocity := 5.2
@export var mouse_sensitivity := 0.002
@export var touch_sensitivity := 0.004
@export var stamina_max := 100.0
var stamina := 100.0
var health := 100.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var camera_pivot: Node3D
var camera: Camera3D
var body_mesh: MeshInstance3D
var collision: CollisionShape3D
var is_sprinting := false
var is_aiming := false

func _ready() -> void:
	_build_body()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if not OS.has_feature("mobile") else Input.MOUSE_MODE_VISIBLE

func _build_body() -> void:
	collision = CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.42
	capsule.height = 1.8
	collision.shape = capsule
	collision.position.y = 0.9
	add_child(collision)
	body_mesh = MeshInstance3D.new()
	var body := CapsuleMesh.new()
	body.radius = 0.42
	body.height = 1.8
	body_mesh.mesh = body
	body_mesh.position.y = 0.9
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.12, 0.32, 0.78)
	body_mesh.material_override = material
	add_child(body_mesh)
	camera_pivot = Node3D.new()
	camera_pivot.name = "CameraPivot"
	camera_pivot.position.y = 1.55
	add_child(camera_pivot)
	camera = Camera3D.new()
	camera.name = "Camera3D"
	camera.position = Vector3(0.8, 1.25, 5.8)
	camera.rotation.x = deg_to_rad(-10)
	camera.current = true
	camera.fov = 78.0
	camera_pivot.add_child(camera)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_rotate_camera(event.relative, mouse_sensitivity)
	elif event is InputEventScreenDrag and OS.has_feature("mobile"):
		var viewport_size := get_viewport().get_visible_rect().size
		if event.position.x >= viewport_size.x * 0.42 and event.position.y <= viewport_size.y * 0.82:
			_rotate_camera(event.relative, touch_sensitivity)
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.pressed and not OS.has_feature("mobile"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _rotate_camera(relative_motion: Vector2, sensitivity: float) -> void:
	camera_pivot.rotate_y(-relative_motion.x * sensitivity)
	camera.rotate_x(-relative_motion.y * sensitivity)
	camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-48), deg_to_rad(32))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var forward := -camera_pivot.global_basis.z
	var right := camera_pivot.global_basis.x
	var direction := (right * input.x + forward * -input.y).normalized()
	is_sprinting = Input.is_action_pressed("sprint") and stamina > 1.0 and input.length() > 0.1
	var target_speed := sprint_speed if is_sprinting else walk_speed
	if is_sprinting:
		stamina = maxf(0.0, stamina - 24.0 * delta)
	else:
		stamina = minf(stamina_max, stamina + 15.0 * delta)
	var control := 1.0 if is_on_floor() else air_control
	var target_velocity := direction * target_speed
	velocity.x = move_toward(velocity.x, target_velocity.x, acceleration * control * delta)
	velocity.z = move_toward(velocity.z, target_velocity.z, acceleration * control * delta)
	if direction.length() > 0.12:
		var target_angle := atan2(-direction.x, -direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, minf(1.0, delta * 12.0))
	move_and_slide()

func take_damage(amount: float) -> void:
	health = maxf(health - amount, 0.0)

func set_vehicle_hidden(hidden: bool) -> void:
	visible = not hidden
	collision.disabled = hidden
	set_physics_process(not hidden)
