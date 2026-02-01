extends Node


@onready var default_keybindings: Dictionary
@onready var changed_binds: Array
signal alert_keybind_changed
@onready var keybind_list = []

func _ready():
	keybind_list = get_all_keybind_actions(true)
	for action in keybind_list:
		default_keybindings[action] = InputMap.action_get_events(action)[0]
		

func keybind_exists(action):
	return action in get_all_keybind_actions()

func keybind_bound(action):
	if keybind_exists(action):
		return InputMap.action_get_events(action).is_empty()
	return false

func get_bind(action):
	if keybind_exists(action):
		var bound_event = InputMap.action_get_events(action)
		
		if bound_event.is_empty():
			return ""
		else:
			return bound_event[0].as_text()
	return null
	
func keybinds_to_events():
	var keybinds_to_events_map = {}
	for keybind in keybind_list:
		keybinds_to_events_map[keybind] = get_bind(keybind)
	return keybinds_to_events_map

func events_to_keybinds():
	var events_to_keybinds_map = {}
	for keybind in keybind_list:
		events_to_keybinds_map[get_bind(keybind)] = keybind
	return events_to_keybinds_map

func bind_taken(event):
	var taken_events = events_to_keybinds()
	if event in taken_events.keys():
		return taken_events[event]
	else:
		return false

func get_all_keybind_actions(force_recheck = false):
	if force_recheck:
		var actions = []
		for action in InputMap.get_actions():
			if action.split("_")[0] != "ui":
				actions.append(action)
		return actions
	else:
		return keybind_list

func erase_keybind(action):
	InputMap	.action_erase_events(action)
	print("removed action", action)
	
func _update_changed_binds():
	changed_binds.clear()
	for keybind in get_all_keybind_actions():
		if get_bind(keybind) != default_keybindings[keybind].as_text():
			changed_binds.append(keybind)


func change_keybind(action, raw_event):
	if InputMap.has_action(action):
		var current_bind = get_bind(action)
		if current_bind:
			InputMap.action_erase_events(action)
		var existing_keybind = bind_taken(raw_event.as_text())
		if existing_keybind:
			erase_keybind(existing_keybind)
		InputMap.action_add_event(action, raw_event)
		_update_changed_binds()
		emit_signal("alert_keybind_changed")
		return true
	return false

func reset_bind_to_default(action):
	change_keybind(action, default_keybindings[action])

func get_changed_keybinds():
	return changed_binds
