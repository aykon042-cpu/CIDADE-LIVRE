extends CanvasLayer
class_name MobileControls

# Touch controls that synthesize the same InputMap actions used by keyboard.
# They are shown only on mobile platforms.
var enabled_on_device := OS.has_feature("mobile")
var _held: Dictionary = {}

func _ready() -> void:
	if not enabled_on_device:
		return
	_build_controls()

func _build_controls() -> void:
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	_add_button(root, "▲", Vector2(28, -170), "move_forward")
	_add_button(root, "▼", Vector2(28, -80), "move_back")
	_add_button(root, "◀", Vector2(118, -80), "move_left")
	_add_button(root, "▶", Vector2(208, -80), "move_right")
	_add_button(root, "CORRER", Vector2(-190, -105), "sprint")
	_add_button(root, "PULAR", Vector2(-100, -195), "jump")
	_add_button(root, "AÇÃO", Vector2(-100, -95), "interact")

func _add_button(root: Control, caption: String, offset: Vector2, action: String) -> void:
	var button := TouchScreenButton.new()
	button.name = "Touch_" + action
	var shape := RectangleShape2D.new()
	shape.size = Vector2(76, 76)
	button.shape = shape
	button.action = action
	button.position = Vector2(110, 0) + offset if offset.x >= 0 else Vector2(get_viewport().get_visible_rect().size.x - 150, get_viewport().get_visible_rect().size.y) + offset
	root.add_child(button)
	var label := Label.new()
	label.text = caption
	label.position = button.position - Vector2(30, 12)
	label.add_theme_font_size_override("font_size", 16)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(label)

func _exit_tree() -> void:
	for action in _held:
		Input.action_release(action)
