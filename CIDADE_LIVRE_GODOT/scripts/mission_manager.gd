extends Node
class_name CityMissionManager

signal mission_started(mission_id: String, title: String)
signal mission_completed(mission_id: String, reward: int)

var missions: Array[Dictionary] = [
	{"id": "first_steps", "title": "Primeiros passos", "description": "Vá até o parque central.", "target": Vector3(0, 0, -24), "radius": 4.0, "reward": 500},
	{"id": "city_explorer", "title": "Explorador urbano", "description": "Visite o cruzamento ao norte.", "target": Vector3(0, 0, -55), "radius": 5.0, "reward": 900},
	{"id": "home_stretch", "title": "Volta para casa", "description": "Retorne ao ponto inicial.", "target": Vector3(0, 0, 13), "radius": 5.0, "reward": 1200}
]
var current_index := 0
var active := false

func restore_mission(mission_id: String) -> void:
	if mission_id == "completed":
		current_index = missions.size()
		active = false
		return
	for index in range(missions.size()):
		if str(missions[index].id) == mission_id:
			current_index = index
			active = false
			return

func start_current() -> void:
	if current_index >= missions.size():
		return
	active = true
	var mission: Dictionary = missions[current_index]
	mission_started.emit(str(mission.id), str(mission.title))

func update_player_position(position: Vector3) -> void:
	if not active:
		return
	var mission: Dictionary = missions[current_index]
	if position.distance_to(mission.target) <= float(mission.radius):
		active = false
		mission_completed.emit(str(mission.id), int(mission.reward))
		current_index += 1
		if current_index < missions.size():
			start_current()

func get_current_description() -> String:
	if current_index >= missions.size():
		return "Todas as missões desta etapa foram concluídas."
	return str(missions[current_index].description)

func get_current_target() -> Vector3:
	if current_index >= missions.size():
		return Vector3.ZERO
	return missions[current_index].target
