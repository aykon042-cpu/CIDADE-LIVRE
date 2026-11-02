extends CharacterBody3D
class_name CityCivilian

@export var move_speed := 1.8
@export var wander_radius := 12.0
var home_position: Vector3
var destination: Vector3
var player_target: Node3D
var flee_radius := 7.0
var wait_time := 0.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var route_points: Array[Vector3] = []
var route_index := 0
var fleeing := false
var flee_timer := 0.0

func _ready() -> void:
	home_position = global_position
	if route_points.is_empty():
		_pick_destination()
	else:
		destination = route_points[route_index % route_points.size()]
	_build_character()

func _build_character() -> void:
	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.32
	capsule.height = 1.65
	collision.shape = capsule
	collision.position.y = 0.82
	add_child(collision)
	var visual := MeshInstance3D.new()
	var mesh := CapsuleMesh.new()
	mesh.radius = 0.32
	mesh.height = 1.65
	visual.mesh = mesh
	visual.position.y = 0.82
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(randf_range(0.2, 0.8), randf_range(0.2, 0.8), randf_range(0.2, 0.8))
	visual.material_override = mat
	add_child(visual)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	var player_near := player_target != null and is_instance_valid(player_target) and global_position.distance_to(player_target.global_position) < flee_radius
	if player_near:
		var escape := global_position - player_target.global_position
		escape.y = 0.0
		if escape.length_squared() > 0.01:
			destination = global_position + escape.normalized() * 12.0
			fleeing = true
			flee_timer = 3.0
			wait_time = 0.0
	elif fleeing:
		flee_timer -= delta
		if flee_timer <= 0.0:
			fleeing = false
			if not route_points.is_empty():
				route_index = _nearest_route_index()
				destination = route_points[route_index]
			else:
				_pick_destination()
	velocity.x = move_toward(velocity.x, 0.0, move_speed * 3.0 * delta)
	velocity.z = move_toward(velocity.z, 0.0, move_speed * 3.0 * delta)
	if wait_time > 0.0:
		wait_time -= delta
	elif fleeing:
		_move_to_destination(1.35)
	else:
		_move_to_destination()
	move_and_slide()

func _move_to_destination(speed_scale: float = 1.0) -> void:
	var direction := destination - global_position
	direction.y = 0.0
	if direction.length() < 0.9:
		wait_time = randf_range(0.4, 1.8)
		if not fleeing:
			_advance_route()
	else:
		var travel := direction.normalized()
		velocity.x = travel.x * move_speed * speed_scale
		velocity.z = travel.z * move_speed * speed_scale
		look_at(Vector3(destination.x, global_position.y, destination.z))

func _advance_route() -> void:
	if route_points.is_empty():
		_pick_destination()
		return
	route_index = (route_index + 1) % route_points.size()
	destination = route_points[route_index]

func _nearest_route_index() -> int:
	var best_index := 0
	var best_distance := INF
	for index in range(route_points.size()):
		var distance := global_position.distance_squared_to(route_points[index])
		if distance < best_distance:
			best_distance = distance
			best_index = index
	return best_index

func _pick_destination() -> void:
	destination = home_position + Vector3(randf_range(-wander_radius, wander_radius), 0, randf_range(-wander_radius, wander_radius))
