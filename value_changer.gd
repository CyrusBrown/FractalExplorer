extends PanelContainer

@onready var program = get_tree().current_scene
var uniforms: Dictionary = {}
@onready var uiroot = %UIRoot
@onready var point_selector_scene = preload("res://point_selector.tscn")
@onready var point_uniforms = $Variables/VBoxContainer

func _ready():
	for point_uniform in ["julia_point", "start_position", "extra_parameter"]:
		var point_selector = point_selector_scene.instantiate()
		refresh_uniforms.connect(point_selector._refresh_uniform)
		point_uniforms.add_child(point_selector)
		point_selector.inital_setup(point_uniform, self, uiroot)
		
signal refresh_uniforms

func change_uniform(uniform_name, value):
	program.set_uniform(uniform_name, value)

func get_uniform_value(uniform_name, default):
	return uniforms.get(uniform_name, default)

func _on_ui_root_ui_closed() -> void:
	pass

func _on_ui_root_ui_opened() -> void:
	uniforms = program.get_current_uniforms()
	self.emit_signal("refresh_uniforms")
