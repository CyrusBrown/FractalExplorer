extends ScrollContainer

@onready var files_container = $ItemList

@onready var directory = owner.directory_path

@export var placeholder_texture: Texture2D

var files = []


func _ready():
	files = Persistance.dir_contents(directory)[1]
	
	files = ["user://code/fractalcode/bruh.txt", "user://code/fractalcode/bruh2.txt"]
	
	for i in range(40):
		files.append("user://code/fractalcode/doozer" + str(i) + ".txt")
	
	for file: String in files:
		var file_name = file.get_file().get_slice(".", 0)
		files_container.add_item(file_name, placeholder_texture, true)
