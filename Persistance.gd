extends Node

func create_user_data_directory(directory_name: String):
	var path = "user://" + directory_name
	
	if DirAccess.dir_exists_absolute(path):
		print("Directory already exists: ", path)
		return

	var error = DirAccess.make_dir_absolute(path)
	
	if error == OK:
		print("Successfully created directory: ", path)
	else:
		printerr("Failed to create directory: ", path, " Error code: ", error)


func _ready():
	create_user_data_directory("code")
	create_user_data_directory("code/fractal")
	create_user_data_directory("code/coloring")

func save_to_file(filename, content):
	print("saving to file", filename)
	var file = FileAccess.open(filename, FileAccess.WRITE)
	var bruh = file.store_string(content)
	file.close()
	
func load_from_file(filename):
	var file = FileAccess.open(filename, FileAccess.READ)
	var content = file.get_as_text()
	return content
	
func is_legit_filename(filename):
	if filename.is_empty() or filename.length() > 255:
		return false

	var illegal_pattern = "[\\/\\?\\%\\*\\:\\|\"\\<\\>\\x00-\\x1F]"
	
	illegal_pattern = illegal_pattern.insert(1, " ")
	
	var regex = RegEx.new()
	regex.compile(illegal_pattern)
	
	if regex.search(filename):
		return false
		
	var reserved_names = []
	if filename.get_basename().to_upper() in reserved_names:
		return false
		
	return true

func save_fractalcode(codename, code):
	#var code_dir = DirAccess.open("user://code/fractalcode")
	save_to_file("user://code/fractalcode".path_join(codename), code)

func dir_contents(path):
	var dir = DirAccess.open(path)
	var dirs = []
	var files = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				dirs.append(file_name)
			else:
				files.append(file_name)
			file_name = dir.get_next()
		return [dirs, files]
	else:
		return [dirs, files]
