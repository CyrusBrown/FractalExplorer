extends PopupBase


@onready var window_title_label = $VBoxContainer/Title
@onready var directory_list = $VBoxContainer/Directory
@onready var action_button = $VBoxContainer/PanelContainer/Button
@onready var file_mode = "select"
@onready var text_area = $VBoxContainer/PanelContainer/TextArea

var exited_success = false
func empty_callback():
	pass
	

var callback: Callable = empty_callback
var options = null
var directory = null
#
#var examples_path = "res://Examples"
#
#@export var directory_path = "user://code/fractalcode"

var selected_file = null

func file_selected(selected, selected_name):
	selected_file = selected
	print(selected)
	text_area.text = selected_name
	action_button.disabled = false
	
func setup():
	if not options:
		print("no options")
		close_self()
	else:
		file_mode = options["file_mode"]
		callback = options["callback"]
		directory = options["directory"]
		print("loading options")
		directory_list.load_dir(directory)
		
		if file_mode == "select":
			select_mode_setup()
		if file_mode == "create":
			create_mode_setup()

func select_mode_setup():
	action_button.disabled = true
	action_button.text = "Load"
	selected_file = null

func create_mode_setup():
	action_button.disabled = true
	action_button.text = "Save"
	selected_file = null

func open_popup(popup_options: Dictionary = {}):
	print(popup_options)
	options = popup_options
	self.show()
	setup()

func on_close():
	directory_list.cleanup()
	print("closing filepicker")
	if not exited_success:
		callback.call(null, options)
	self.options = null
	self.file_mode = null
	self.selected_file = null
	text_area.text = ""
	
func _ready():
	pass

func _action_button_pressed() -> void:
	print("path_selected")
	print(selected_file)
	exited_success = true
	callback.call(selected_file, options)
	close_self()


func _on_text_area_text_changed(new_text: String) -> void:
	if file_mode == "create":
		if Persistance.is_legit_filename(new_text):
			action_button.disabled = false
			selected_file = new_text
		else:
			action_button.disabled = true
	
