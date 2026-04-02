extends PopupBase
@onready var uiroot = %UIRoot

var exited_success = false
var clicked_position = Vector2(0, 0)
func empty_callback():
	pass

var callback: Callable = empty_callback
var options = null

	
func setup():
	if not options:
		print("no options")
		close_self()
	else:
		callback = options["callback"]
		clicked_position = Vector2(0, 0)

func open_popup(popup_options: Dictionary = {}):
	self.mouse_filter = Control.MOUSE_FILTER_STOP
	print(popup_options)
	options = popup_options
	self.show()
	uiroot.mainui.hide()
	setup()

func on_close():
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE	
	print("closing point picker")
	options["popup_size"] = size
	if not exited_success:
		callback.call(null, options)
	else:
		callback.call(clicked_position, options)
	self.options = null
	uiroot.mainui.show()
	
func _ready():
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			accept_event() 
			make_input_local(event)
			clicked_position = event.position
			exited_success = true
			close_self()
