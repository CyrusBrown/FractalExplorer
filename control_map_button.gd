extends HBoxContainer

@export var input_action: String

@onready var action_label = $Label
@onready var input_button = $InputMapButton
@onready var reset_button = $Reset
@onready var alias: String
@onready var mapped_input

func _ready():
	reset_button.disabled = true
	reset_button.self_modulate = Color(1.0, 1.0, 1.0, 0)
	KeybindManager.connect("alert_keybind_changed", _keybind_changed)
	_set_text()
	input_button.connect("pressed", _button_pressed)
	reset_button.connect("pressed", _reset_keybind)
	
	set_process_input(false)
	

func _set_text():
	if KeybindManager.keybind_exists(input_action):
		mapped_input = KeybindManager.get_bind(input_action)
		if not mapped_input:
			mapped_input = "Not bound"
	else:
		mapped_input = "Not an action, somehow"
	input_button.text = mapped_input
	
	if Aliases.control_aliases.has(input_action):
		alias = Aliases.control_aliases[input_action]
	else:
		alias = input_action
		
	if input_action in KeybindManager.changed_binds:
		reset_button.disabled = false
		reset_button.self_modulate = Color(1.0, 1.0, 1.0, 1.0)

	
	action_label.text = alias


func _button_pressed():
	input_button.text = "Press input to bind..."
	set_process_input(true)
	
func _reset_keybind():
	KeybindManager.reset_bind_to_default(input_action)
	reset_button.disabled = true
	reset_button.self_modulate = Color(1.0, 1.0, 1.0, 0)

func _keybind_changed():
	_set_text()
	

func _input(event: InputEvent) -> void:
	var new_input = event
	
	if event is InputEventKey or event is InputEventMouseButton:
		KeybindManager.change_keybind(input_action, new_input)
		set_process_input(false)
