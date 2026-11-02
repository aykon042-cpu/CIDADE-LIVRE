extends Node3D

const PLAYER_SCRIPT = preload("res://scripts/player.gd")
const POLICE_SCRIPT = preload("res://scripts/police.gd")
const CIVILIAN_SCRIPT = preload("res://scripts/civilian.gd")
const VEHICLE_SCRIPT = preload("res://scripts/vehicle.gd")
const MOBILE_CONTROLS_SCRIPT = preload("res://scripts/mobile_controls.gd")
const MISSION_MANAGER_SCRIPT = preload("res://scripts/mission_manager.gd")
const SAVE_MANAGER_SCRIPT = preload("res://scripts/save_manager.gd")
const TRAFFIC_SCRIPT = preload("res://scripts/traffic_vehicle.gd")
const HOUSE_SCRIPT = preload("res://scripts/residential_house.gd")
const SHOP_SCRIPT = preload("res://scripts/shop.gd")
const TRAFFIC_SIGNAL_SCRIPT = preload("res://scripts/traffic_signal.gd")
var player: CharacterBody3D
var wanted_level := 0
var money := 250
var hud_label: Label
var mission_label: Label
var mission_done := false
var mission_manager: Node
var mobile_controls: CanvasLayer
var save_timer := 0.0
var starter_vehicle: VehicleBody3D
var current_vehicle: VehicleBody3D
var traffic_cars: Array[VehicleBody3D] = []
var sun_light: DirectionalLight3D
var day_clock := 0.25
var police_officer: CharacterBody3D
var health_bar: ProgressBar
var mission_marker: MeshInstance3D
var marker_material: StandardMaterial3D
var houses: Array[Node3D] = []
var shops: Array[Node3D] = []
var traffic_signals: Array[Node3D] = []

func _ready() -> void:
	_build_environment()
	_build_city()
	_spawn_player()
	_build_hud()
	_spawn_population()
	_spawn_vehicle()
	_spawn_traffic_signals()
	_spawn_traffic()
	_spawn_police()
	_setup_game_systems()
	_update_hud()

func _build_environment() -> void:
	var world_env := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_SKY
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.65, 0.72, 0.85)
	env.ambient_light_energy = 0.7
	world_env.environment = env
	add_child(world_env)
	sun_light = DirectionalLight3D.new()
	var sun := sun_light
	sun.rotation_degrees = Vector3(-48, -30, 0)
	sun.light_energy = 1.1
	add_child(sun)
	var ground := StaticBody3D.new()
	ground.name = "Ground"
	var mesh := MeshInstance3D.new()
	var plane := BoxMesh.new()
	plane.size = Vector3(180, 1, 180)
	mesh.mesh = plane
	mesh.position.y = -0.5
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.18, 0.24, 0.19)
	mesh.material_override = mat
	ground.add_child(mesh)
	var col := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(180, 1, 180)
	col.shape = box
	col.position.y = -0.5
	ground.add_child(col)
	add_child(ground)

func _build_city() -> void:
	for i in range(-4, 5):
		_add_box(Vector3(i * 20.0, 0.02, 0), Vector3(8, 0.04, 180), Color(0.12, 0.12, 0.13), "Road_NS")
		_add_box(Vector3(0, 0.03, i * 20.0), Vector3(180, 0.04, 8), Color(0.12, 0.12, 0.13), "Road_EW")
	for x in range(-4, 5):
		for z in range(-4, 5):
			if abs(x) < 2 and abs(z) < 2:
				continue
			if Vector2i(x, z) in [Vector2i(-2, -2), Vector2i(-2, 2), Vector2i(2, -2), Vector2i(2, 2), Vector2i(-3, 0), Vector2i(3, 0), Vector2i(0, -3), Vector2i(0, 3), Vector2i(-3, -2)]:
				continue
			var h := randf_range(7.0, 24.0)
			var w := randf_range(7.0, 12.0)
			var d := randf_range(7.0, 12.0)
			var pos := Vector3(x * 20.0 + randf_range(-3, 3), h / 2.0, z * 20.0 + randf_range(-3, 3))
			_add_box(pos, Vector3(w, h, d), Color(randf_range(0.25, 0.65), randf_range(0.25, 0.65), randf_range(0.28, 0.7)), "Building")
	_add_box(Vector3(0, 0.08, 0), Vector3(18, 0.12, 18), Color(0.15, 0.38, 0.18), "CentralPark")
	_spawn_houses()
	_spawn_shops()

func _spawn_houses() -> void:
	for cell in [Vector2i(-2, -2), Vector2i(-2, 2), Vector2i(2, -2), Vector2i(2, 2), Vector2i(-3, 0), Vector2i(3, 0)]:
		var house := Node3D.new()
		house.set_script(HOUSE_SCRIPT)
		house.name = "ResidentialHouse_%02d" % houses.size()
		# Give every home its own exterior and interior palette before it builds.
		house.set("style_index", houses.size())
		# Center each home inside its block, clear of the surrounding road lanes.
		house.position = Vector3(cell.x * 20.0 + 10.0, 0.0, cell.y * 20.0 + 10.0)
		add_child(house)
		houses.append(house)

func _spawn_shops() -> void:
	var definitions := [
		{"cell": Vector2i(0, -3), "name": "Farmácia Central", "price": 75, "heal": 55.0, "color": Color(0.2, 0.65, 0.42)},
		{"cell": Vector2i(0, 3), "name": "Mercado Popular", "price": 35, "heal": 25.0, "color": Color(0.85, 0.58, 0.16)},
		{"cell": Vector2i(-3, -2), "name": "Clínica Vida", "price": 110, "heal": 85.0, "color": Color(0.25, 0.48, 0.82)}
	]
	for definition in definitions:
		var shop := Node3D.new()
		shop.set_script(SHOP_SCRIPT)
		shop.name = str(definition.name).replace(" ", "")
		shop.set("shop_name", definition.name)
		shop.set("service_price", definition.price)
		shop.set("service_amount", definition.heal)
		shop.set("accent_color", definition.color)
		var cell: Vector2i = definition.cell
		shop.position = Vector3(cell.x * 20.0 + 10.0, 0.0, cell.y * 20.0 + 10.0)
		add_child(shop)
		shops.append(shop)

func _add_box(pos: Vector3, size: Vector3, color: Color, node_name: String) -> void:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = pos
	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	mesh_instance.material_override = material
	body.add_child(mesh_instance)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)
	add_child(body)

func _spawn_player() -> void:
	player = CharacterBody3D.new()
	player.set_script(PLAYER_SCRIPT)
	player.name = "Player"
	player.position = Vector3(0, 1, 13)
	add_child(player)

func _spawn_population() -> void:
	var pedestrian_routes: Array[Array] = [
		[Vector3(-11.0, 0.0, -11.0), Vector3(11.0, 0.0, -11.0), Vector3(11.0, 0.0, 11.0), Vector3(-11.0, 0.0, 11.0)],
		[Vector3(-16.0, 0.0, -7.0), Vector3(-16.0, 0.0, 7.0), Vector3(-7.0, 0.0, 16.0), Vector3(7.0, 0.0, 16.0)],
		[Vector3(16.0, 0.0, 7.0), Vector3(16.0, 0.0, -7.0), Vector3(7.0, 0.0, -16.0), Vector3(-7.0, 0.0, -16.0)]
	]
	for i in range(12):
		var npc := CharacterBody3D.new()
		npc.set_script(CIVILIAN_SCRIPT)
		var route: Array = pedestrian_routes[i % pedestrian_routes.size()]
		npc.set("route_points", route)
		npc.set("route_index", int(i / pedestrian_routes.size()) % route.size())
		npc.position = route[int(i / pedestrian_routes.size()) % route.size()] + Vector3(0.0, 1.0, 0.0)
		npc.name = "Civilian_%02d" % i
		npc.player_target = player
		add_child(npc)

func _spawn_vehicle() -> void:
	var car := VehicleBody3D.new()
	car.set_script(VEHICLE_SCRIPT)
	car.position = Vector3(5, 1, 10)
	car.name = "StarterVehicle"
	for p in [Vector3(-0.8, 0.25, -1.1), Vector3(0.8, 0.25, -1.1), Vector3(-0.8, 0.25, 1.1), Vector3(0.8, 0.25, 1.1)]:
		var wheel := VehicleWheel3D.new()
		wheel.position = p
		wheel.wheel_radius = 0.35
		wheel.wheel_rest_length = 0.2
		wheel.use_as_steering = absf(p.z) > 0.5 and p.z < 0
		wheel.use_as_traction = true
		car.add_child(wheel)
	add_child(car)
	starter_vehicle = car

func _spawn_traffic() -> void:
	for lane_x in [-20.0, 20.0, 40.0]:
		var traffic := VehicleBody3D.new()
		traffic.set_script(TRAFFIC_SCRIPT)
		traffic.position = Vector3(lane_x, 1.0, randf_range(-55.0, 55.0))
		traffic.waypoints = [Vector3(lane_x, 0.0, -82.0), Vector3(lane_x, 0.0, 82.0)]
		traffic.traffic_color = Color(randf_range(0.12, 0.8), randf_range(0.12, 0.8), randf_range(0.12, 0.8))
		if not traffic_signals.is_empty():
			traffic.traffic_signal = traffic_signals[traffic_cars.size() % traffic_signals.size()]
		for wheel_pos in [Vector3(-0.8, 0.25, -1.1), Vector3(0.8, 0.25, -1.1), Vector3(-0.8, 0.25, 1.1), Vector3(0.8, 0.25, 1.1)]:
			var wheel := VehicleWheel3D.new()
			wheel.position = wheel_pos
			wheel.wheel_radius = 0.35
			wheel.wheel_rest_length = 0.2
			wheel.use_as_steering = wheel_pos.z < 0.0
			wheel.use_as_traction = true
			traffic.add_child(wheel)
		add_child(traffic)
		traffic_cars.append(traffic)

func _spawn_traffic_signals() -> void:
	for lane_x in [-20.0, 20.0, 40.0]:
		var signal_node := Node3D.new()
		signal_node.set_script(TRAFFIC_SIGNAL_SCRIPT)
		signal_node.name = "TrafficSignal_%d" % traffic_signals.size()
		signal_node.position = Vector3(lane_x + 3.0, 0.0, 0.0)
		add_child(signal_node)
		traffic_signals.append(signal_node)

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact"):
		return
	if current_vehicle != null:
		if current_vehicle.has_method("exit_vehicle"):
			current_vehicle.exit_vehicle()
		current_vehicle = null
		return
	if starter_vehicle != null and player != null and player.global_position.distance_to(starter_vehicle.global_position) <= 4.0:
		if starter_vehicle.has_method("enter_vehicle"):
			starter_vehicle.enter_vehicle(player)
			current_vehicle = starter_vehicle
		return
	var nearest_house: Node3D
	var nearest_distance := 4.0
	for house in houses:
		if not is_instance_valid(house):
			continue
		var distance := player.global_position.distance_to(house.global_position)
		if distance <= nearest_distance:
			nearest_distance = distance
			nearest_house = house
	if nearest_house != null and nearest_house.has_method("interact"):
		nearest_house.interact(player)
		return
	var nearest_shop: Node3D
	nearest_distance = 4.5
	for shop in shops:
		if not is_instance_valid(shop):
			continue
		var distance := player.global_position.distance_to(shop.global_position)
		if distance <= nearest_distance:
			nearest_distance = distance
			nearest_shop = shop
	if nearest_shop != null and nearest_shop.has_method("interact"):
		var message: String = nearest_shop.interact(player, self)
		if not message.is_empty():
			mission_label.text = message
			_update_hud()

func _spawn_police() -> void:
	var officer := CharacterBody3D.new()
	officer.set_script(POLICE_SCRIPT)
	officer.position = Vector3(-18, 1, -12)
	officer.name = "PoliceOfficer"
	officer.target = player
	police_officer = officer
	add_child(officer)

func _build_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var panel := PanelContainer.new()
	panel.position = Vector2(18, 18)
	panel.custom_minimum_size = Vector2(270, 96)
	layer.add_child(panel)
	var column := VBoxContainer.new()
	panel.add_child(column)
	hud_label = Label.new()
	hud_label.add_theme_font_size_override("font_size", 18)
	column.add_child(hud_label)
	health_bar = ProgressBar.new()
	health_bar.max_value = 100.0
	health_bar.value = 100.0
	health_bar.custom_minimum_size = Vector2(230, 14)
	column.add_child(health_bar)
	mission_label = Label.new()
	mission_label.text = "MISSÃO: Explore a cidade e encontre o marcador."
	column.add_child(mission_label)
	var help := Label.new()
	help.text = "WASD: mover | Shift: correr | Espaço: pular | E: interagir / comprar"
	column.add_child(help)

func _setup_game_systems() -> void:
	mobile_controls = MOBILE_CONTROLS_SCRIPT.new()
	add_child(mobile_controls)
	mission_manager = MISSION_MANAGER_SCRIPT.new()
	mission_manager.name = "MissionManager"
	add_child(mission_manager)
	mission_manager.mission_started.connect(_on_mission_started)
	mission_manager.mission_completed.connect(_on_mission_completed)
	var saved: Dictionary = SAVE_MANAGER_SCRIPT.load_game()
	if not saved.is_empty():
		var saved_position: Array = saved.get("player_position", [])
		if saved_position.size() == 3:
			player.global_position = Vector3(float(saved_position[0]), float(saved_position[1]), float(saved_position[2]))
		var saved_vehicle_position: Array = saved.get("vehicle_position", [])
		if saved_vehicle_position.size() == 3 and starter_vehicle != null:
			starter_vehicle.global_position = Vector3(float(saved_vehicle_position[0]), float(saved_vehicle_position[1]), float(saved_vehicle_position[2]))
		money = int(saved.get("money", money))
		wanted_level = clampi(int(saved.get("wanted_level", wanted_level)), 0, 5)
		mission_manager.restore_mission(str(saved.get("mission_id", "first_steps")))
	mission_manager.start_current()
	_build_mission_marker()
	_update_mission_marker()
	mission_label.text = "MISSÃO: " + mission_manager.get_current_description()

func _on_mission_started(_mission_id: String, title: String) -> void:
	mission_label.text = "MISSÃO: " + title
	_update_mission_marker()

func _on_mission_completed(_mission_id: String, reward: int) -> void:
	money += reward
	mission_label.text = "MISSÃO CONCLUÍDA! +$%d" % reward
	_update_hud()
	_save_progress()

func _save_progress() -> void:
	var mission_id := "completed"
	if mission_manager != null and mission_manager.current_index < mission_manager.missions.size():
		mission_id = str(mission_manager.missions[mission_manager.current_index].id)
	SAVE_MANAGER_SCRIPT.save_game(player, money, wanted_level, mission_id, starter_vehicle)

func _process(delta: float) -> void:
	day_clock = fposmod(day_clock + delta / 900.0, 1.0)
	if sun_light != null:
		sun_light.rotation_degrees.x = lerpf(-15.0, -165.0, day_clock)
		sun_light.light_energy = lerpf(0.25, 1.1, clampf(sin(day_clock * PI), 0.0, 1.0))
	if police_officer != null:
		police_officer.wanted_level = wanted_level
	if player != null and health_bar != null:
		health_bar.value = float(player.get("health"))
	if mission_marker != null:
		mission_marker.rotate_y(delta * 0.8)
	if mission_manager != null:
		var mission_position := player.global_position if player != null else Vector3.ZERO
		if current_vehicle != null:
			mission_position = current_vehicle.global_position
		mission_manager.update_player_position(mission_position)
	save_timer += delta
	if save_timer >= 30.0:
		save_timer = 0.0
		_save_progress()

func _build_mission_marker() -> void:
	mission_marker = MeshInstance3D.new()
	mission_marker.name = "MissionWaypoint"
	var ring := TorusMesh.new()
	ring.inner_radius = 1.4
	ring.outer_radius = 1.8
	mission_marker.mesh = ring
	mission_marker.position.y = 0.25
	marker_material = StandardMaterial3D.new()
	marker_material.albedo_color = Color(1.0, 0.78, 0.12)
	marker_material.emission_enabled = true
	marker_material.emission = Color(1.0, 0.55, 0.05)
	mission_marker.material_override = marker_material
	add_child(mission_marker)

func _update_mission_marker() -> void:
	if mission_marker == null or mission_manager == null:
		return
	if mission_manager.current_index >= mission_manager.missions.size():
		mission_marker.visible = false
		return
	mission_marker.visible = true
	var target: Vector3 = mission_manager.get_current_target()
	mission_marker.global_position = target + Vector3.UP * 0.3

func _exit_tree() -> void:
	_save_progress()

func _update_hud() -> void:
	if hud_label:
		hud_label.text = "CIDADE LIVRE\nDinheiro: $%d\nProcurado: %s" % [money, "★".repeat(wanted_level)]
