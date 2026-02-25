extends HBoxContainer

#@onready var section_selector = $SectionSelector
var current_section = 0
@onready var uiroot = %UIRoot

@onready var editor = $"../../FractalcodeEditor"

func _on_section_selector_item_selected(index: int) -> void:
	current_section = index
	editor.change_section(current_section)

func _load_file(filepath, options):
	if filepath:
		var directory = options["directory"]
		filepath = directory.path_join(filepath)
		var code = Persistance.load_from_file(filepath)
		editor.load_code(code)
	else:
		print("FAILED LOAD")

func get_save_path():
	if current_section == 0:
		return "user://code/fractal"
	elif current_section == 1:
		return "user://code/coloring"
	
func _save_file(filepath, options):
	if filepath:
		filepath = filepath + ".dzrcode"
		var code = editor.text
		print("SAVING FILE")
		print(filepath)
		filepath = get_save_path().path_join(filepath)
		Persistance.save_to_file(filepath, code)
	else:
		print("FAILED CREATE")

func _on_load_pressed() -> void:
	var options = {
		"callback": Callable(self, "_load_file"),
		"file_mode": "select",
		"directory": get_save_path()
	}
	uiroot.Popups.open_popup("file_select", options)

func _on_save_pressed() -> void:
	var options = {
		"callback": Callable(self, "_save_file"),
		"file_mode": "create",
		"directory": get_save_path()
	}
	uiroot.Popups.open_popup("file_select", options)


func _on_examples_pressed() -> void:
	var path = ""
	if current_section == 0:
		path =  "res://examples/fractal"
	elif current_section == 1:
		path = "res://examples/coloring"
	var options = {
		"callback": Callable(self, "_load_file"),
		"file_mode": "select",
		"directory": path
	}
	uiroot.Popups.open_popup("file_select", options)
