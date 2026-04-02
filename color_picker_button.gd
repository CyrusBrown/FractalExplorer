extends ColorPickerButton

@onready var valueschanger = %ValuesChanger
@onready var color_map = Vector3(0.0, 0.0, 0.0)
#@onready var intensity = 0

func _on_values_changer_refresh_uniforms() -> void:
	print("EFIJEIFJEF")
	color_map = valueschanger.get_uniform_value("color_map", Vector3(0.0, 0.0, 0.0))
	print(color_map)
	self.color.r = color_map.x
	self.color.g = color_map.y
	self.color.b = color_map.z

func _on_color_changed(color: Color) -> void:
	color_map = Vector3(color.r, color.g, color.b)
	#intensity = color.in
	valueschanger.change_uniform("color_map", color_map)
