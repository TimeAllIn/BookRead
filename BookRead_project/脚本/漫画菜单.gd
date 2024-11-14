extends Panel


func 漫画菜单(event: InputEvent) -> void:
	if event is InputEventMouseButton:  
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			$"..".set_visible(false)
			pass


func 亮度改变(value: float) -> void:
	var set_color:= Color((value+1)*0.5,(value+1)*0.5,(value+1)*0.5,1)
	$"../..".set_self_modulate(set_color)
	$"../../容器".set_modulate(set_color)
	pass

func 菜单显示() -> void:
	var temp_value = float($"../..".now_page)/float(Data.comic_array().size() - 3)
	$"../下方菜单/页码".set_value(temp_value)
	pass


func 页码改变(value: float) -> void:
	$"../..".now_page = int((float(Data.comic_array().size())-2.5) * value)
	$"../..".page_update()
	pass
