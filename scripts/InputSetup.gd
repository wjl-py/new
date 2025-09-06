extends Node

func _enter_tree() -> void:
	_add_action_if_missing("move_forward", [KEY_W, KEY_UP])
	_add_action_if_missing("move_back", [KEY_S, KEY_DOWN])
	_add_action_if_missing("move_left", [KEY_A, KEY_LEFT])
	_add_action_if_missing("move_right", [KEY_D, KEY_RIGHT])
	_add_action_if_missing("interact", [KEY_E, KEY_SPACE])
	_add_action_if_missing("grade_correct", [KEY_J])
	_add_action_if_missing("grade_incorrect", [KEY_K])
	_add_action_if_missing("pause", [KEY_ESCAPE])

func _add_action_if_missing(action_name: String, default_keys: Array) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
		for keycode in default_keys:
			var ev := InputEventKey.new()
			ev.physical_keycode = keycode
			InputMap.action_add_event(action_name, ev)
