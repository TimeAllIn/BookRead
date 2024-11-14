extends Panel
const book = preload("res://预制体/漫画书目.tscn")
const book_con = preload("res://预制体/漫画目录.tscn")
func _ready() -> void:
	OS.request_permissions()
	#寻找书籍
	var comic_dir = DirAccess.open(Data.comic_start_path+Data.comic_path)
	if comic_dir :
		print("打开成功")	
		Data.pathArray.append(Data.comic_start_path+Data.comic_path)		
		comic_dir.list_dir_begin()
		var file_name = comic_dir.get_next()
		while file_name != "":
			if comic_dir.current_is_dir():
				print("发现目录：" + file_name)
				var add_book = book_con.instantiate()
				#书籍名称归档
				add_book.comic_name = file_name
				add_book.set_head()
				$"分区界面/漫画区/漫画区/容器/容器".add_child(add_book)
			else:			
				#防止文件不对应
				if not file_name.ends_with(Data.comic_end_with):
					continue
				file_name = back_file_name(file_name)
				print("发现文件：" + file_name)
				#此处开始添加书籍
				var add_book = book.instantiate()
				#书籍名称归档
				add_book.comic_name = file_name
				add_book.set_head()
				$"分区界面/漫画区/漫画区/容器/容器".add_child(add_book)
				
				#全局变量储存
				var temp_array:Array
				Data.comic[file_name] = temp_array
				
			file_name = comic_dir.get_next()
	else :	
		print("无文件夹创建")
		var dir = DirAccess.open(Data.comic_start_path)
		dir.make_dir_recursive(Data.comic_start_path + Data.comic_path)
	
	Data.move_book = $"分区界面/漫画区/漫画区/容器"
	Data.move_book_con = $"分区界面/漫画区/漫画目录/容器"

#返回文件名称,不含有后缀
func back_file_name(file_name:String):
	return file_name.rstrip("." + Data.comic_end_with)
