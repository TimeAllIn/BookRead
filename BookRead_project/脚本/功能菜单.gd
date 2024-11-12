extends Panel
func 漫画按钮() -> void:
	$"../分区界面/漫画区".set_visible(true)
	$"../分区界面/增添区".set_visible(false)
	$"../分区界面/个人区".set_visible(false)
	pass
func 添加按钮() -> void:

	$"../漫画添加".current_dir = "/storage/emulated/0/"
	$"../漫画添加".set_visible(true)
	
	pass
func 个人按钮() -> void:
	$"../分区界面/漫画区".set_visible(false)
	$"../分区界面/增添区".set_visible(false)
	$"../分区界面/个人区".set_visible(true)
	pass

const comic_book = preload("res://预制体/漫画书目.tscn")
func 漫画资源选中(path: String) -> void:
	
	if ResourceLoader.exists(path):
		var load_file = ResourceLoader.load(path) as save_data
		var temp_book = comic_book.instantiate()
		$"../分区界面/漫画区/漫画区/容器/容器".add_child(temp_book)
		temp_book.comic = load_file.comic
		temp_book.now_page = 0
		temp_book.set_head()
		pass
	pass


func 目录选取(dir: String) -> void:
	print(dir)
	$"../分区界面/个人区/Label".text = dir
	return
	pass # Replace with function body.
