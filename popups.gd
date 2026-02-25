extends Control



@onready var popups = {
	"file_select": $MarginContainer/FileSelect
}

var popup_open = false
var current_popup = ""

func _ready():
	print("popup: ready")
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE

func open_popup(new_popup, data={}):
	print("popup: opened")
	self.mouse_filter = Control.MOUSE_FILTER_STOP
	if popup_open:
		popups[current_popup].close_popup()
	if new_popup in popups.keys():
		popups[new_popup].open_popup(data)
		current_popup = new_popup
		popup_open = true
	
func close_popups():
	print("popup: closed")
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if popup_open:
		popups[current_popup].close_popup()
		popup_open = false
	current_popup = ""
	
func _input(event: InputEvent) -> void:
	if popup_open:
		if event is InputEventKey and event.is_pressed() or event is InputEventMouseButton and event.is_pressed():
			if event.is_action("toggle_ui"):
				get_viewport().set_input_as_handled()
				close_popups()
				accept_event()

		
