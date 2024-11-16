extends Panel

#在程序唤醒的第一帧运行，且只运行一次
func _ready() -> void:
	$"版本".text = "版本号:"+ ProjectSettings.get_setting("application/config/version")

	pass
