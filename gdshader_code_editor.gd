class_name gdshader_editor_base
extends CodeEdit


var default_text = """// Write any code you like
// The renderer will use the fractal function each iteration
// The following is code for the mandlebrot set

vec2 fractal(vec2 z, vec2 c){
	return (cmult(z, z) + c);
}


"""

var highlighter: CodeHighlighter

var editor_settings = {
	"symbol_lookup_on_click": true,
	"symbol_tooltip_on_hover": true,
	"line_folding": true,
	"gutters_draw_line_numbers": true,
	"gutters_zero_pad_line_numbers": false,
	"gutters_draw_fold_gutter": true,
	
	"code_completion_enabled": true,
	
	"auto_brace_completion_enabled": true,
	"auto_brace_completion_highlight_matching": true,
	
	"text": default_text,
	
	"caret_blink": true,
	
	"highlight_all_occurrences": true,
	"highlight_current_line": true
}

var highlighter_settings = {
	"symbol_color": Color(0.67, 0.79, 1.0),
	"number_color": Color(0.63, 1.0, 0.88),
	"function_color": Color(0.34, 0.7, 1.0),
	"member_variable_color": Color(0.736, 0.88, 1.0),
	#"keyword_color": Color(1.0, 0.44, 0.52),
	#"control_flow_keyword_color": Color(1.0, 0.55, 0.8),
	#"comment_color": Color(0.803, 0.81, 0.822, 0.5),
	"color_regions": {
		"//  ": Color(0.803, 0.81, 0.822, 0.5),
		'" "': Color(1.0, 0.93, 0.63)
	},
	"keyword_colors":
		{
		"keyword": Color(1.0, 0.44, 0.52),
		"control_flow": Color(1.0, 0.55, 0.8),
		"builtin_functions": Color(1.0, 0.44, 0.52),
		}
}

@export var testcolor = Color(1.0, 0.44, 0.52)

var highlighter_keywords = {
	"keyword": ["vec2", "vec3", "vec4", "int", "float", "bool", "void", "length", "true", "false",
				"mat2", "mat3", "mat4", "discard", "bvec2", "bvec3", "bvec4", "const", "ivec2", 
				"ivec3", "ivec4", "uvec2", "uvec3", "uvec4", "uint"],
	"control_flow": ["while", "if", "else", "break", "return", "switch", "case", "default"],
	"builtin_functions": ["radians", "degrees", "sin", "cos", "tan", "asin", "acos", "atan", "sinh", 
						"cosh", "tanh", "asinh", "acosh", "atanh", "pow", "exp", "exp2", "log",
						"log2", "sqrt", "inversesqrt", "abs", "sign", "sign", "floor", "round",
						"roundEven", "trunc", "ceil", "fract", "mod", "modf", "min", "max",
						"clamp", "mix", "fma", "step", "smoothstep", "isnan", "isinf", 
						"floatBitsToInt", "floatBitsToUInt", "intBitsToFloat", "uintBitsToFloat",
						"length", "distance", "dot", "cross", "normalize", "reflect", "refract",
						"faceforward", "matrixCompMult", "outerProduct", "transpose", "determinant",
						"inverse", "lessThan", "greaterThan", "lessThanEqual", "greaterThanEqual",
						"equal", "notEqual", "any", "all", "not", "bitfieldExtract", "bitfieldInsert",
						"bitfieldReverse", "bitCount", "findLSB", "findMSB", "imulExtended", "umulExtended",
						"uaddCarry", "usubBorrow", "ldexp", "frexp"]
}



func _load_settings():
	for key in editor_settings.keys():
		if get(key) != null:
			set(key, editor_settings[key])
	
	

func _load_syntax_highlighter():
	var gdshader_highlighter = CodeHighlighter.new()
	
	for key in highlighter_settings.keys():
		if gdshader_highlighter.get(key) != null:
			gdshader_highlighter.set(key, highlighter_settings[key])
	
	for group in highlighter_keywords.keys():
		var group_color = highlighter_settings["keyword_colors"][group]
		for keyword in highlighter_keywords[group]:
			gdshader_highlighter.add_keyword_color(keyword, group_color)
	
	highlighter = gdshader_highlighter

func _load_editor():
	_load_settings()
	_load_syntax_highlighter()
	syntax_highlighter = highlighter
	
func _ready():
	_load_editor()
	
