extends Control

var ui_active = false

@onready var fractalcode_editor: Node = find_child("FractalcodeEditor", true)
@onready var code_options: Node = find_child("CodeOptions", true)
var newcode: String
@onready var program = self.get_parent()
@onready var Popups: Node = $Popups

func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	pass

func toggle_ui():
	if ui_active:
		show()
	else:
		hide()


func _on_fractalcode_changed() -> void:
	newcode = fractalcode_editor.text
	match code_options.current_section:
		0:
				program.load_fractalcode(newcode)
		1:
				program.load_colorcode(newcode)
