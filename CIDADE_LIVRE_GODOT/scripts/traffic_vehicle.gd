extends VehicleBody3D
class_name CityTrafficVehicle

@export var cruise_force := 75.0
@export var waypoint_reach := 4.0
@export var steering_gain := 0.55
var waypoints: Array[Vector3] = []
var waypoint_index := 0
var stopped := false

func _ready() -> void:
	if waypoints.is_empty():
		waypoints = [global_position + Vector3(0, 0, -80), global_position + Vector3(80, 0, -80), global_position + Vector3(80, 0, 0), global_position]
	for wheel in get_children():
		if wheel is VehicleWheel3D:
			wheel.use_as_traction = true
			wheel.wheel_friction_slip = 2.0

func _physics_process(_delta: float) -> void:
	if stopped or waypoints.is_empty():
		engine_force = 0.0
		brake = 12.0
		return
	var target := waypoints[waypoint_index]
	var local_target := global_transform.affine_inverse() * target
	if global_position.distance_to(target) <= waypoint_reach:
		waypoint_index = (waypoint_index + 1) % waypoints.size()
		target = waypoints[waypoint_index]
		local_target = global_transform.affine_inverse() * target
	var angle := atan2(local_target.x, -local_target.z)
	steering = clampf(angle * steering_gain, -0.45, 0.45)
	engine_force = cruise_force * clampf(1.0 - absf(angle), 0.25, 1.0)
	brake = 0.0

func set_traffic_light(red: bool) -> void:
	stopped = red
