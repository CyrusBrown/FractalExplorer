extends PanelContainer

var valueschanger

var point_uniform = ""
@onready var uiroot
@onready var point_label = $HBoxContainer/UniformLabel
var point_value = Vector2(0, 0)
@onready var x_selector = $HBoxContainer/VBoxContainer/XSelector/SpinBox
@onready var y_selector = $HBoxContainer/VBoxContainer/YSelector/SpinBox
@onready var reset_x = $HBoxContainer/VBoxContainer2/Button
@onready var reset_y = $HBoxContainer/VBoxContainer2/Button2

func inital_setup(uniform_name, values_changer, ui_root):
	uiroot = ui_root
	point_uniform = uniform_name
	valueschanger = values_changer
	print("EIFEIJI", uniform_name)
	print(point_label)
	point_label.text = Aliases.control_aliases.get(uniform_name, uniform_name)
	_refresh_uniform()

func _refresh_uniform():
	point_value = valueschanger.get_uniform_value(point_uniform,  Vector2(0, 0))
	x_selector.value = point_value.x
	y_selector.value = point_value.y

func _on_x_value_changed(value: float) -> void:
	point_value.x = value
	valueschanger.change_uniform(point_uniform, point_value)

func _on_y_value_changed(value: float) -> void:
	point_value.y = value
	valueschanger.change_uniform(point_uniform, point_value)


func _on_reset_x_pressed() -> void:
	x_selector.value = 0.0
	_on_x_value_changed(0.0)

func _on_reset_y_pressed() -> void:
	y_selector.value = 0.0
	_on_y_value_changed(0.0)

	
func _select_popup_callback(clicked_position, options):
	var zoom = valueschanger.get_uniform_value("zoom",  1.0)
	var sprite_scale = valueschanger.get_uniform_value("sprite_scale",  Vector2(1.0, 1.0))
	var offset = valueschanger.get_uniform_value("offset",  Vector2(1.0, 1.0))
	if clicked_position:
		clicked_position = clicked_position / options["popup_size"]
		var clicked_point = (((clicked_position - Vector2(0.5, 0.5)) * (sprite_scale / Vector2(zoom, zoom))) + Vector2(0.5, 0.5)) * Vector2(1, -1) + offset
		x_selector.value = clicked_point.x
		y_selector.value = clicked_point.y
		_on_x_value_changed(clicked_point.x)
		_on_y_value_changed(clicked_point.y)
		
func _on_select_point_button_pressed() -> void:
	var popup_options = {
		"callback": Callable(self, "_select_popup_callback")
	}
	uiroot.Popups.open_popup("point_select", popup_options)
	
