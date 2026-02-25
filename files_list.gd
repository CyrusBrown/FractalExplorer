extends ScrollContainer

@onready var files_container = $ItemList

@export var placeholder_texture: Texture2D

var files = []

var filenames = []


var selected = null

func _ready():
	cleanup()

func load_dir(directory, thumbnail_directory):
	print("LOADING DIRECTORY", directory)
	files = Persistance.dir_contents(directory)[1]
	var thumbnail_files = Persistance.dir_contents(thumbnail_directory)[1]
	var thumbnail_filenames = {}
	
	for file: String in thumbnail_files:
		var file_name = file.get_file().get_slice(".", 0)
		thumbnail_filenames[file_name] = thumbnail_directory.path_join(file)
	print(files)
	
	#files = ["user://code/fractalcode/bruh.txt", "user://code/fractalcode/bruh2.txt"]
	#
	#for i in range(40):
		#files.append("user://code/fractalcode/doozer" + str(i) + ".txt")
	
	for file: String in files:
		print(file)
		var file_name = file.get_file().get_slice(".", 0)
		filenames.append(file_name)
		var texture = placeholder_texture
		if file_name in thumbnail_filenames.keys():
			var image = Image.new()
			print("image path ", thumbnail_filenames[file_name])
			var error = image.load(thumbnail_filenames[file_name])
			if error == OK:
				texture = ImageTexture.create_from_image(image) # Use static method in Godot 4
			else:
				print("Failed to load image: ", error)
		files_container.add_item(file_name, texture, true)
		
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
