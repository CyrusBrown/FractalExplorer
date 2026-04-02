extends Control

var ui_active = false

@onready var fractalcode_editor: Node = find_child("FractalcodeEditor", true)
@onready var code_options: Node = find_child("CodeOptions", true)
var newcode: String
@onready var mainui = $MainUI
@onready var program = self.get_parent()
@onready var Popups: Node = $Popups

func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	pass
	
signal ui_opened
signal ui_closed

func toggle_ui():
	if ui_active:
		show()
		emit_signal("ui_opened")
	else:
		hide()
		emit_signal("ui_closed")


func _on_fractalcode_changed() -> void:
	newcode = fractalcode_editor.text
	match code_options.current_section:
		0:
				program.load_fractalcode(newcode)
		1:
				program.load_colorcode(newcode)
