extends Node3D
class_name CityTrafficSignal

@export var green_duration := 12.0
@export var yellow_duration := 2.5
@export var red_duration := 12.0
var phase_time := 0.0
var phase := 0
var red_light: MeshInstance3D
var yellow_light: MeshInstance3D
var green_light: MeshInstance3D

func _ready() -> void:
	_build_signal()
	_update_lamps()

func _process(delta: float) -> void:
	phase_time += delta
	var duration := green_duration if phase == 0 else yellow_duration if phase == 1 else red_duration
	if phase_time >= duration:
		phase_time = 0.0
		phase = (phase + 1) % 3
		_update_lamps()

func is_red_for_vehicle(_vehicle_position: Vector3, _vehicle_velocity: Vector3) -> bool:
	return phase == 2

func _build_signal() -> void:
	var pole := MeshInstance3D.new()
	var pole_mesh := CylinderMesh.new()
	pole_mesh.top_radius = 0.09
	pole_mesh.bottom_radius = 0.13
	pole_mesh.height = 4.5
	pole.mesh = pole_mesh
	pole.position.y = 2.25
	_add_material(pole, Color(0.12, 0.13, 0.15))
	add_child(pole)
	var housing := MeshInstance3D.new()
	var housing_mesh := BoxMesh.new()
	housing_mesh.size = Vector3(0.55, 1.65, 0.38)
	housing.mesh = housing_mesh
	housing.position = Vector3(0, 4.15, 0)
	_add_material(housing, Color(0.055, 0.06, 0.07))
	add_child(housing)
	red_light = _lamp(Vector3(0, 4.65, 0.22), Color(1.0, 0.08, 0.04))
	yellow_light = _lamp(Vector3(0, 4.15, 0.22), Color(1.0, 0.62, 0.05))
	green_light = _lamp(Vector3(0, 3.65, 0.22), Color(0.08, 1.0, 0.2))

func _lamp(pos: Vector3, color: Color) -> MeshInstance3D:
	var lamp := MeshInstance3D.new()
	var sphere := SphereMesh.new()
	sphere.radius = 0.16
	sphere.height = 0.32
	lamp.mesh = sphere
	lamp.position = pos
	_add_material(lamp, color)
	add_child(lamp)
	return lamp

func _add_material(mesh: MeshInstance3D, color: Color) -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.emission_enabled = true
	material.emission = color
	material.emission_energy_multiplier = 0.8
	mesh.material_override = material

func _update_lamps() -> void:
	if red_light == null:
		return
	_set_lamp(red_light, phase == 2, Color(1.0, 0.08, 0.04))
	_set_lamp(yellow_light, phase == 1, Color(1.0, 0.62, 0.05))
	_set_lamp(green_light, phase == 0, Color(0.08, 1.0, 0.2))

func _set_lamp(lamp: MeshInstance3D, enabled: bool, color: Color) -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = color if enabled else color.darkened(0.82)
	material.emission_enabled = enabled
	material.emission = color if enabled else Color.BLACK
	lamp.material_override = material
