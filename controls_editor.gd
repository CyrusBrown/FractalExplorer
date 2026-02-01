extends PanelContainer

@onready var ControlsEditor = $ControlsEditor
@onready var ControlsSearch = $ControlsEditor/ControlsSearch
@onready var ControlsList = $ControlsEditor/ScrollContainer/ControlsList
@onready var control_mappers = []
@onready var control_map = preload("res://control_map.tscn")

func _ready():
	var actions = KeybindManager.get_all_keybind_actions()
	for action in actions:
		var new_control_button = control_map.instantiate()
		new_control_button.input_action = action
		control_mappers.append(new_control_button)
		ControlsList.add_child(new_control_button)
		
	ControlsSearch.connect("text_changed", _search_updated)
	

func _search_updated(new_text: String):
	if new_text == "":
		for control_mapper in control_mappers:
			control_mapper.show()
	else:
		for control_mapper in control_mappers:
			control_mapper.hide()
			if control_mapper.alias.to_lower().find(new_text.to_lower()) != -1:
				control_mapper.show()
	
