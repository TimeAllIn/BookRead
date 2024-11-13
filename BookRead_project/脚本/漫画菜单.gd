extends Panel


func 漫画菜单(event: InputEvent) -> void:
	if event is InputEventMouseButton:  
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			$"../具体菜单".set_visible(!$"../具体菜单".is_visible())
			pass
