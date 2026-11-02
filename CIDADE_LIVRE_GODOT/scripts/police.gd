extends CharacterBody3D
class_name CityPolice

@export var move_speed := 5.5
@export var detection_radius := 24.0
var target: Node3D
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
	if target == null or not is_instance_valid(target):
		return
	var distance := global_position.distance_to(target.global_position)
	if distance > detection_radius:
		return
	var direction := target.global_position - global_position
	direction.y = 0
	if direction.length() > 1.5:
		velocity.x = direction.normalized().x * move_speed
		velocity.z = direction.normalized().z * move_speed
		look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z))
	else:
		velocity.x = 0
		velocity.z = 0
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()
