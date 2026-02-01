extends HBoxContainer

#@onready var section_selector = $SectionSelector
var current_section = 0
@onready var uiroot = %UIRoot

@onready var editor = $"../../FractalcodeEditor"

func _on_section_selector_item_selected(index: int) -> void:
	current_section = index
	editor.change_section(current_section)


func _on_load_pressed() -> void:
	uiroot.Popups.open_popup("file_select")

func _on_save_pressed() -> void:
	uiroot.Popups.open_popup("file_select")
