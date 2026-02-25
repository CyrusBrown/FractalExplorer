extends Control

@onready var renderer = $Renderer
@onready var ui = %UIRoot
@onready var render_shader: Shader = load("res://Shaders/fractal_renderer.gdshader")
@onready var image_render_shader: Shader = load("res://Shaders/renderer_renderer.gdshader")
@onready var base_renderer: Shader = load("res://Shaders/fractal_renderer_base.gdshader")
 
var current_fractalcode: String
var current_colorcode: String
var current_fractalcode_filename: String
var default_uniforms = {}

var ui_open = false

# TODO/IDEAS
# 1. Custom logger to use errors in code editor
# 2. Code to prevent the GODDAMN margin shifting when switching to double didget line numbers
# 3. Custom uniforms in fractal code
# 4. Way to render current view as png
# DONE 5. Saving/loading fractal equations
# 6. Custom shaderincludes...? to use between multiple files (or editing the functions one)
# 7. More functions in the functions one
# 8. Editing main renderer file 
# DONE 9. Editing color methods
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
# DONE 25. Github release
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
		print("FAILED INJECTION")
		return false
	else: 
		print("INJECTED RENDERER")
		return true
		
func render_into_image_texture(fractalcode, colorcode, image_size, use_default_uniforms = false):
	# 1. Create temporary SubViewport and TextureRect
	var new_viewport = SubViewport.new()
	new_viewport.size = image_size
	new_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	
	var new_rect = TextureRect.new()
	new_rect.custom_minimum_size = image_size
	new_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	
	new_rect.texture = PlaceholderTexture2D.new()
	new_rect.texture.size = image_size
	
	var new_mat = ShaderMaterial.new()
	new_mat.shader = image_render_shader
	var current_uniforms = {}
	if use_default_uniforms:
		current_uniforms = default_uniforms
	else:
		current_uniforms = renderer.uniforms
	var new_shader = base_renderer.code
	new_shader = new_shader.replace("//@#@#FRACTAL_CODE@#@#", fractalcode)
	new_shader = new_shader.replace("//@#@#COLOR_CODE@#@#", colorcode)
	new_rect.material = new_mat
	new_mat.shader.code = new_shader
	
	print(new_mat.shader.get_shader_uniform_list())
	for uniform in new_mat.shader.get_shader_uniform_list():
		new_mat.set_shader_parameter(uniform["name"], current_uniforms[uniform["name"]])
	
	new_viewport.add_child(new_rect)
	add_child(new_viewport)
	
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	
	var image: Image = new_viewport.get_texture().get_image()
	
	new_viewport.queue_free()
	
	return image

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
		if event.is_action_pressed("toggle_ui"):
			ui_open = not ui_open
			renderer.renderer_active = not ui_open
			ui.ui_active = ui_open
			ui.toggle_ui()
