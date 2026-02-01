extends TabContainer

@export var tabnames: Array[String]

func _ready():
	for tab_index in range(tabnames.size()):
		set_tab_title(tab_index, tabnames[tab_index])
