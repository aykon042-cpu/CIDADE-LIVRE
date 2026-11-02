extends Node
class_name CitySaveManager

const SAVE_PATH := "user://cidade_livre_save.json"
const SAVE_VERSION := 1

static func save_game(player: Node3D, money: int, wanted_level: int, mission_id: String) -> bool:
	if player == null:
		return false
	var payload := {
		"version": SAVE_VERSION,
		"player_position": [player.global_position.x, player.global_position.y, player.global_position.z],
		"money": money,
		"wanted_level": wanted_level,
		"mission_id": mission_id,
		"saved_at_unix": Time.get_unix_time_from_system()
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Não foi possível abrir o arquivo de save: %s" % FileAccess.get_open_error())
		return false
	file.store_string(JSON.stringify(payload))
	return file.get_error() == OK

static func load_game() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Não foi possível ler o save.")
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("Save inválido; iniciando novo jogo.")
		return {}
	if int(parsed.get("version", 0)) != SAVE_VERSION:
		push_warning("Versão de save incompatível.")
		return {}
	return parsed
