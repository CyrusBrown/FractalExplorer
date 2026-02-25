extends ColorRect

@export_range(0, 50, 0.2) var move_speed: float
@export_range(0, 1, 0.01) var zoom_speed: float
@export_range (0,1,0.01) var intensity: float = 0.5

@onready var Program = $".."

# good move speed is 7.4
# good zoom speed is 0.1

var renderer_active = true
var julia_point = Vector2(0,0)
var zoom_factor = 2
var fractal_offset = scale / -10
var max_iter = 35
#var color_map = Vector3(0.0, 2.0, 4.0)
var color_map = Vector3(0.0, 2.8, 4.8)
var fractal_type = 0
#var equation = 0
var start_position = Vector2(-0, 0)
var define_start = 0
var earlyescape = 2.0
var draw_points = 1
var extra_parameter = Vector2(0, 0)
var toggle_earlyescape = true
#@export var equations = 3

var uniforms = {}

#15.019
#8.438

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	uniforms = {
		"zoom": zoom_factor,
		"sprite_scale": size * 0.008,
		"offset": fractal_offset,
		"max_iterations": max_iter,
		"intensity_fac": intensity,
		"julia_point": julia_point,
		"color_map": color_map,
		"fractal_type": fractal_type,
		"start_position": start_position,
		"define_start": define_start,
		"earlyescape": earlyescape,
		"draw_points": draw_points,
		"extra_parameter": extra_parameter,
		"toggle_earlyescape": toggle_earlyescape
	}
	
	for uniform_name in uniforms.keys():
		update_uniform(uniform_name)
	
	Program.default_uniforms = uniforms

func update_uniform(uniform):
	var value = null
	match uniform:
		"zoom": 
			value = zoom_factor
		"sprite_scale": 
			value = size * 0.008
		"offset": 
			value = fractal_offset
		"max_iterations": 
			value = round(max_iter)
		"intensity_fac": 
			value = intensity
		"julia_point": 
			value = julia_point
		"color_map": 
			value = color_map
		"fractal_type": 
			value = fractal_type
		"start_position": 
			value = start_position
		"define_start": 
			value = define_start
		"earlyescape": 
			value = earlyescape
		"draw_points": 
			value = draw_points
		"extra_parameter": 
			value = extra_parameter
		"toggle_earlyescape": 
			value = toggle_earlyescape
		_:
			push_warning("Uniform %s not a valid uniform" % uniform)
			return
			
	material.set_shader_parameter(uniform, value)
	uniforms[uniform] = value
				
func _unhandled_input(event: InputEvent) -> void:
	var mouse_inside
	if renderer_active:
		if event is InputEventMouseButton:
			mouse_inside = self.get_rect().has_point(event.position)
			if mouse_inside:
				if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
					if zoom_factor > 0:
						zoom_factor -= zoom_factor * zoom_speed  
						max_iter -= log(zoom_factor) * zoom_speed * 1.5
				if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
					zoom_factor += zoom_factor * zoom_speed
					max_iter += log(zoom_factor) * zoom_speed * 1.5
				update_uniform("zoom")
				
		
		if event is InputEventKey and event.is_pressed():
			if event.is_action("reset_view"):
				zoom_factor = 2
				fractal_offset = scale / -10
				max_iter = 70
				start_position = Vector2(-0,0)
				earlyescape = 2.0
				extra_parameter = Vector2(0, 0)
				update_uniform("zoom")
				update_uniform("offset")
				update_uniform("max_iterations")
				update_uniform("earlyescape")
			
			if event.is_action("debug_points"):
				print("Julia: ", julia_point)
				print("start_position: ", start_position)
				print("Coloring", color_map)
				print("Extra", extra_parameter)
				print("Type", fractal_type)
			
			if event.is_action("toggle_earlyescape"):
				toggle_earlyescape = not toggle_earlyescape
			
			if event.is_action("toggle_julia"):
				fractal_type = 1 - fractal_type
				print("type", fractal_type)
				
			if event.is_action("define_start"):
				define_start = 1 - define_start
				print("define", define_start)
				
			if event.is_action("draw_points"):
				draw_points = 1 - draw_points
				
			
			#if event.keycode == KEY_BRACKETRIGHT:
				#equation += 1
				#if equation > equations - 1:
					#equation = 0
				#print(equation)
			#if event.keycode == KEY_BRACKETLEFT:
				#equation -= 1
				#if equation < 0:
					#equation = equations - 1
				#print(equation)

			
				
			
			if Input.is_action_pressed("factor_modifier_1"):
				if event.is_action("increase_iter"):
					max_iter += 10
				if event.is_action("decrease_iter"):
					max_iter -= 10
			else:
				if event.is_action("increase_iter"):
					max_iter += 1
				if event.is_action("decrease_iter"):
					max_iter -= 1
			
					
		#update_uniform("equation", equation)
		
		update_uniform("max_iterations")
		update_uniform("fractal_type")
		update_uniform("define_start")
		update_uniform("draw_points")
		update_uniform("toggle_earlyescape")
		
				
var nudge_factor = 1
func _process(delta):
	update_uniform("sprite_scale")
	if renderer_active:
		if Input.is_action_pressed("zoom_out_smooth"):
			if zoom_factor > 0:
				zoom_factor -= zoom_factor * 0.1 / 4.669201 
				max_iter -= log(zoom_factor) *  0.1 / 4.669201 * 3
		if Input.is_action_pressed("zoom_in_smooth"):
			zoom_factor += zoom_factor *  0.1 / 4.669201  
			max_iter += log(zoom_factor) *  0.1 / 4.669201 * 3
		update_uniform("zoom")
		update_uniform("max_iterations")
		
		if Input.is_action_pressed("move_up"):
			fractal_offset += Vector2(0,-0.01) / zoom_factor * move_speed
		if Input.is_action_pressed("move_left"):
			fractal_offset += Vector2(-0.01,0) / zoom_factor * move_speed
		if Input.is_action_pressed("move_down"):
			fractal_offset += Vector2(0,0.01) / zoom_factor * move_speed
		if Input.is_action_pressed("move_right"):
			fractal_offset += Vector2(0.01,0) / zoom_factor * move_speed
			
		if Input.is_action_pressed("move_start_up"):
			start_position += Vector2(0,-0.01) / zoom_factor * nudge_factor
		if Input.is_action_pressed("move_start_left"):
			start_position += Vector2(-0.01,0) / zoom_factor * nudge_factor
		if Input.is_action_pressed("move_start_down"):
			start_position += Vector2(0,0.01) / zoom_factor * nudge_factor
		if Input.is_action_pressed("move_start_right"):
			start_position += Vector2(0.01,0) / zoom_factor * nudge_factor

		
		if Input.is_action_pressed("factor_modifier_1"):
			nudge_factor = 0.1
		elif Input.is_action_pressed("factor_modifier_2"):
			nudge_factor = 0.0005
		elif Input.is_action_pressed("factor_modifier_3"):
			nudge_factor = 0.00005
		else:
			nudge_factor = 1
		
		if Input.is_action_pressed("extra_parameter"):
			if Input.is_action_pressed("move_julia_up"):
				extra_parameter += Vector2(0,-0.01) / zoom_factor * nudge_factor
			if Input.is_action_pressed("move_julia_left"):
				extra_parameter += Vector2(-0.01,0) / zoom_factor * nudge_factor
			if Input.is_action_pressed("move_julia_down"):
				extra_parameter += Vector2(0,0.01) / zoom_factor * nudge_factor
			if Input.is_action_pressed("move_julia_right"):
				extra_parameter += Vector2(0.01,0) / zoom_factor * nudge_factor
		else:
			if Input.is_action_pressed("move_julia_up"):
				julia_point += Vector2(0,-0.01) / zoom_factor * nudge_factor
			if Input.is_action_pressed("move_julia_left"):
				julia_point += Vector2(-0.01,0) / zoom_factor * nudge_factor
			if Input.is_action_pressed("move_julia_down"):
				julia_point += Vector2(0,0.01) / zoom_factor * nudge_factor
			if Input.is_action_pressed("move_julia_right"):
				julia_point += Vector2(0.01,0) / zoom_factor * nudge_factor
			

		
		if Input.is_key_pressed(KEY_KP_MULTIPLY):
			intensity += 0.01
		if Input.is_key_pressed(KEY_KP_DIVIDE):
			intensity -= 0.01
			
		if Input.is_action_pressed("red_up"):
			color_map.x += 0.01
		if Input.is_action_pressed("green_up"):
			color_map.y += 0.01
		if Input.is_action_pressed("green_up"):
			color_map.z += 0.01

		if Input.is_action_pressed("red_down"):
			color_map.x -= 0.01
		if Input.is_action_pressed("green_down"):
			color_map.y -= 0.01
		if Input.is_action_pressed("blue_down"):
			color_map.z -= 0.01
			
		if Input.is_action_pressed("earlyescape_down"):
			earlyescape -= 0.1 / nudge_factor
		if Input.is_action_pressed("earlyescape_up"):
			earlyescape +=  0.1 / nudge_factor
		
			
		update_uniform("start_position")
		update_uniform("color_map")
		update_uniform("offset")
		update_uniform("intensity_fac")
		update_uniform("julia_point")
		update_uniform("earlyescape")
		update_uniform("extra_parameter")

	
