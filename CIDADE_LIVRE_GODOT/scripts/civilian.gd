extends CharacterBody3D
class_name CityCivilian

@export var move_speed := 1.8
@export var wander_radius := 12.0
var home_position: Vector3
var destination: Vector3
var wait_time := 0.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	home_position = global_position
	_pick_destination()
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
	if wait_time > 0.0:
		wait_time -= delta
	else:
		var direction := destination - global_position
		direction.y = 0
		if direction.length() < 1.0:
			wait_time = randf_range(1.0, 4.0)
			_pick_destination()
		else:
			velocity.x = direction.normalized().x * move_speed
			velocity.z = direction.normalized().z * move_speed
			look_at(Vector3(destination.x, global_position.y, destination.z))
	move_and_slide()

func _pick_destination() -> void:
	destination = home_position + Vector3(randf_range(-wander_radius, wander_radius), 0, randf_range(-wander_radius, wander_radius))
