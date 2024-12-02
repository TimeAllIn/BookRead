extends Panel

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST and $"漫画目录".is_visible() and not $"../../漫画内容区(竖直)".is_visible():
		Data.open_dir(Data.pathArray[Data.pathArray.size()-2])
		pass
