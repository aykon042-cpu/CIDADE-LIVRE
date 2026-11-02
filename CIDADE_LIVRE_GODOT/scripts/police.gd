extends CharacterBody3D
class_name CityPolice

@export var move_speed := 5.5
@export var detection_radius := 24.0
@export var search_radius := 42.0
var target: Node3D
var wanted_level := 0
var last_known_position := Vector3.ZERO
var search_time := 0.0
var has_last_known_position := false
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.4
	capsule.height = 1.8
	collision.shape = capsule
	collision.position.y = 0.9
	add_child(collision)
	var visual := MeshInstance3D.new()
	var mesh := CapsuleMesh.new()
	mesh.radius = 0.4
	mesh.height = 1.8
	visual.mesh = mesh
	visual.position.y = 0.9
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.05, 0.12, 0.35)
	visual.material_override = mat
	add_child(visual)

func _physics_process(delta: float) -> void:
	if wanted_level <= 0 or target == null or not is_instance_valid(target):
		if wanted_level <= 0:
			has_last_known_position = false
		velocity.x = move_toward(velocity.x, 0.0, move_speed * delta)
		velocity.z = move_toward(velocity.z, 0.0, move_speed * delta)
		if not is_on_floor():
			velocity.y -= gravity * delta
		move_and_slide()
		return
	if not has_last_known_position:
		last_known_position = target.global_position
		has_last_known_position = true
	var distance := global_position.distance_to(target.global_position)
	if distance <= detection_radius:
		last_known_position = target.global_position
		search_time = 0.0
	elif distance > search_radius:
		search_time += delta
		if search_time > 12.0:
			wanted_level = 0
			return
	var direction := last_known_position - global_position
	direction.y = 0.0
	if direction.length() > 1.5:
		var pursuit_speed := move_speed + float(maxi(wanted_level - 1, 0)) * 1.25
		velocity.x = direction.normalized().x * pursuit_speed
		velocity.z = direction.normalized().z * pursuit_speed
		look_at(Vector3(last_known_position.x, global_position.y, last_known_position.z))
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()
