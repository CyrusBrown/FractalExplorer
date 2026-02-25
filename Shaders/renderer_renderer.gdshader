shader_type canvas_item;

#include "functions.gdshaderinc"

uniform highp float zoom : hint_range(0.1, 10.0) = 1.0;
uniform vec2 sprite_scale = vec2(1.0, 1.0);   // Zoom level (control zoom via screen space)
uniform highp vec2 offset = vec2(0.0, 0.0);
uniform highp vec2 julia_point = vec2(0.0,0.0);    // Camera offset for panning (in screen space)     // Sprite's current scale
uniform vec3 color_map = vec3(0.0, 2.0, 4.0);
uniform int fractal_type = 0;
uniform int define_start = 0;
uniform int equation = 0;
uniform highp vec2 start_position = vec2(0,0);
uniform float earlyescape = 2.0;
uniform bool draw_points = true;

uniform int max_iterations = 20;


//@#@#FRACTAL_CODE@#@#

//@#@#COLOR_CODE@#@#

void vertex() {
    // Shift UV to center
    highp vec2 centered_uv = (UV - vec2(0.5, 0.5));

    // Apply zoom and compensate for sprite scale
    centered_uv *=  sprite_scale / zoom;

    // Shift UV back to original range
    UV = centered_uv + vec2(0.5, 0.5);

    // Apply panning offset
    UV += offset;
}

uniform float intensity_fac;

vec3 compute_fractal(highp float x, highp float y) {
    int iterations = 0;
	highp vec2 z = (fractal_type == 1 || (fractal_type == 0 && define_start == 0)) ? vec2(x, y) : start_position;
    highp vec2 c = (fractal_type == 0) ? vec2(x,y) : julia_point;

    while (iterations < max_iterations) {
        iterations++;
        if (length(z) > earlyescape) {
            break;
        } else {
            z = fractal(z, c);
        }
    }
	return vec3(float(iterations), z.x, z.y);
}


//vec3 compute_newton(highp float x, highp float y) {
	//int sector = 0;
	//highp vec2 z = vec2(x,y);
	//
	//while (iterations < max_iterations) {
		//iterations++
		//
	//}



void fragment() {
    highp float xpos = UV.x;
    highp float ypos = UV.y;
	vec3 result;

	float start_pos_distance = pow((start_position.x - xpos),2) + pow((start_position.y - ypos),2);
	float julia_distance = pow((julia_point.x - xpos),2) + pow((julia_point.y - ypos),2);


	if (julia_distance < pow((0.05 / zoom),2) && draw_points){
		COLOR = vec4(1,0,0, 1);
	}

	else if (start_pos_distance < pow((0.05 / zoom),2) && draw_points){
		COLOR = vec4(0,1,0, 1);
	}

	else{
		result = compute_fractal(xpos, ypos);
	int iterations = int(result.x);
	vec2 end_pos = vec2(result.y, result.z);
	COLOR = get_pixel_color_5(iterations, max_iterations, intensity_fac, color_map, end_pos);
	}
}
