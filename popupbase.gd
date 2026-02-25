class_name PopupBase
extends PanelContainer

func empty_callback():
	pass

func open_popup(options: Dictionary = {}):
	self.show()
	
func on_close():
	pass

func close_popup():
	self.on_close()
	self.hide()

func close_self():
	%UIRoot.Popups.close_popups();
