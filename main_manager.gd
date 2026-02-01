extends Control

@onready var renderer = $Renderer
@onready var ui = %UIRoot
@onready var render_shader: Shader = load("res://Shaders/fractal_renderer.gdshader")
@onready var base_renderer: Shader = load("res://Shaders/fractal_renderer_base.gdshader")
 
var current_fractalcode: String
var current_colorcode: String
var current_fractalcode_filename: String

var ui_open = false

# TODO/IDEAS
# 1. Custom logger to use errors in code editor
# 2. Code to prevent the GODDAMN margin shifting when switching to double didget line numbers
# 3. Custom uniforms in fractal code
# 4. Way to render current view as png
# 5. Saving/loading fractal equations
# 6. Custom shaderincludes...? to use between multiple files (or editing the functions one)
# 7. More functions in the functions one
# 8. Editing main renderer file 
# 9. Editing color methods
# 10. Changing move speeds
# 11. OPTIMIZATION
# 12. Settings save per equation...?
# 13. Region bookmarking
# 14. Colormap saving 
# 15. Web version
# 16. Detect when rendering takes too long and stop to prevent freezes
# 17. Resolution changing
# 18. Device stats (fps and wtv)
# 19. Theme editing 
# 20. Code completion (fine)
# 21. Change inputs of coloring method to a dictonary
# 22. Code editor in another window...?
# 23. Saved equation picker with thumbnails...?
# 24. Home screen? Splash screen?
# 25. Github release
# 26. Fix formatting issue when binding new key (slight shift)
# 27. Is the mouse button "all devices" thing gonna mess stuff up
# 28. Controlling points in gui
# 29. Controlling points in polar form
	
	
func _inject_renderer(fractalcode, colorcode, force = false):
	var current_fractalcode = render_shader.code
	var new_fractalcode = base_renderer.code
	new_fractalcode = new_fractalcode.replace("//@#@#FRACTAL_CODE@#@#", fractalcode)
	new_fractalcode = new_fractalcode.replace("//@#@#COLOR_CODE@#@#", colorcode)
	render_shader.code = new_fractalcode
	if render_shader.get_shader_uniform_list().is_empty() and not force:
		render_shader.code = current_fractalcode
		return false
	else: 
		return true


func load_fractalcode(new_fractalcode, force = false):
	var result = _inject_renderer(new_fractalcode, current_colorcode, force)
	if result:
		current_fractalcode = new_fractalcode

func load_colorcode(new_colorcode, force = false):
	var result = _inject_renderer(current_fractalcode, new_colorcode, force)
	if result:
		current_colorcode = new_colorcode
	
func _ready() -> void:
	var default_fractalcode = Persistance.load_from_file("res://Shaders/default_fractalcode.gdshaderinc")
	var default_colorcode = Persistance.load_from_file("res://Shaders/default_colorcode.gdshaderinc")
	_inject_renderer(default_fractalcode, default_colorcode, true)
	current_fractalcode = default_fractalcode
	current_colorcode = default_colorcode
					
	ui_open = false
	renderer.renderer_active = true
	ui.ui_active = false

func _process(delta: float) -> void:
	pass

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.is_action("toggle_ui"):
			ui_open = not ui_open
			renderer.renderer_active = not ui_open
			ui.ui_active = ui_open
			ui.toggle_ui()
