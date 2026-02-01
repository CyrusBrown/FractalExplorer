extends gdshader_editor_base


var default_fractalcode = Persistance.load_from_file("res://Shaders/default_fractalcode.gdshaderinc")
var default_colorcode = Persistance.load_from_file("res://Shaders/default_colorcode.gdshaderinc")

var current_fractalcode = ""
var current_colorcode = ""
var current_section = 0

func _ready():
	self._load_editor()
	current_fractalcode = default_fractalcode
	current_colorcode = default_colorcode
	self.text = current_fractalcode

func change_section(index):
	current_section = index
	match current_section:
		0: self.text = current_fractalcode
		1: self.text = current_colorcode
	self.emit_signal("text_changed")

func _on_text_changed() -> void:
	match current_section:
		0: current_fractalcode = self.text
		1: current_colorcode = self.text
