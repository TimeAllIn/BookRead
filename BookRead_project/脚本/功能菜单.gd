extends Panel
func 漫画按钮() -> void:
	$"../分区界面/漫画区".set_visible(true)
	$"../分区界面/增添区".set_visible(false)
	$"../分区界面/个人区".set_visible(false)
	pass
func 添加按钮() -> void:
	$"../分区界面/漫画区".set_visible(false)
	$"../分区界面/增添区".set_visible(true)
	$"../分区界面/个人区".set_visible(false)
	pass
func 个人按钮() -> void:
	$"../分区界面/漫画区".set_visible(false)
	$"../分区界面/增添区".set_visible(false)
	$"../分区界面/个人区".set_visible(true)
	pass
