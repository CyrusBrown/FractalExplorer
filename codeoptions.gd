extends HBoxContainer

#@onready var section_selector = $SectionSelector
var current_section = 0
@onready var uiroot = %UIRoot

@onready var Program = get_tree().current_scene

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

func get_save_path(directory = "code"):
	if current_section == 0:
		match directory:
			"code": return "user://code/fractal"
			"thumbnails": return "user://thumbnails/fractal"
			_: 	print("no directory")

	elif current_section == 1:
		match directory:
			"code": return "user://code/coloring"
			"thumbnails": return "user://thumbnails/coloring"
			_: 	print("no directory")

	else:
		print("no current section somehow")

func _save_file(filename, options):
	var filepath = filename
	print("FILENAME ", filename)
	if filepath:
		filepath = filepath + ".dzrcode"
		var code = ""
		var other_code = ""
		if current_section == 0:
			code = editor.current_fractalcode
			other_code = editor.current_colorcode
		elif current_section == 1:
			code = editor.current_colorcode
			other_code = editor.current_fractalcode
		print("SAVING FILE")
		print(filepath)
		filepath = get_save_path().path_join(filepath)
		Persistance.save_to_file(filepath, code)
		
		var image_texture = null
		if current_section == 0:
			image_texture = await Program.render_into_image_texture(code, other_code, Vector2(284, 149))
		elif current_section == 1:
			image_texture = await Program.render_into_image_texture(editor.default_fractalcode, code, Vector2(284, 149), true)
		
		print("saving image to ", get_save_path("thumbnails").path_join(filename + ".png"))
		image_texture.save_png(get_save_path("thumbnails").path_join(filename + ".png"))
		
	else:
		print("FAILED CREATE")

func _on_load_pressed() -> void:
	var options = {
		"callback": Callable(self, "_load_file"),
		"file_mode": "select",
		"directory": get_save_path(),
		"thumbnail_directory": get_save_path("thumbnails")
	}
	uiroot.Popups.open_popup("file_select", options)

func _on_save_pressed() -> void:
	var options = {
		"callback": Callable(self, "_save_file"),
		"file_mode": "create",
		"directory": get_save_path(),
		"thumbnail_directory": get_save_path("thumbnails")
	}
	uiroot.Popups.open_popup("file_select", options)


func _on_examples_pressed() -> void:
	var path = ""
	var thumbnail_path = ""
	if current_section == 0:
		path =  "res://examples/fractal/code"
		thumbnail_path = "res://examples/fractal/thumbnails"
	elif current_section == 1:
		path = "res://examples/coloring/code"
		thumbnail_path =  "res://examples/coloring/thumbnails"
	var options = {
		"callback": Callable(self, "_load_file"),
		"file_mode": "select",
		"directory": path
	}
	uiroot.Popups.open_popup("file_select", options)
