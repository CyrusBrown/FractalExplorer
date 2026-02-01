extends Node


func save_to_file(filename, content):
	var file = FileAccess.open(filename, FileAccess.WRITE)
	file.store_string(content)
	
func load_from_file(filename):
	var file = FileAccess.open(filename, FileAccess.READ)
	var content = file.get_as_text()
	return content

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
