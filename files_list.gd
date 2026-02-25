extends ScrollContainer

@onready var files_container = $ItemList

@export var placeholder_texture: Texture2D

var files = []

var filenames = []

var selected = null

func _ready():
	cleanup()

func load_dir(directory):
	print("LOADING DIRECTORY", directory)
	files = Persistance.dir_contents(directory)[1]
	print(files)
	
	#files = ["user://code/fractalcode/bruh.txt", "user://code/fractalcode/bruh2.txt"]
	#
	#for i in range(40):
		#files.append("user://code/fractalcode/doozer" + str(i) + ".txt")
	
	for file: String in files:
		print(file)
		var file_name = file.get_file().get_slice(".", 0)
		filenames.append(file_name)
		files_container.add_item(file_name, placeholder_texture, true)
		
func cleanup():
	files = []
	filenames = []
	files_container.clear()
		
func name_exists(file_name):
	return file_name in filenames
	
func _on_item_list_item_selected(index: int) -> void:
	print(files)
	selected = files[index]
	owner.file_selected(selected, filenames[index])
