extends Node


#"/storage/emulated/0/"
#漫画所在位置
var comic_path:String = "BookRead/comics"

#初始位置
#var comic_start_path:String = "user://"
var comic_start_path:String = "/storage/emulated/0/"

#漫画后缀设置
var comic_end_with:String = "BookRead"
#漫画字典Key:漫画名称	Value:漫画数组
var comic:Dictionary

#漫画展示区
var comic_show
  
#当前阅览的漫画
var now_look

#滑动速度
var speed:float = 1

#滑动位置，主页书籍
var move_book
var move_book_con

func comic_array():
	return comic.get(now_look.comic_name)

func comic_name_to(comic_name):
	return comic.get(comic_name)

func comic_page():
	return now_look.now_page

#const book = preload("res://预制体/漫画书目.tscn")
const book= preload("res://预制体/漫画书籍按钮/漫画书籍按钮.tscn")
const book_con = preload("res://预制体/漫画目录.tscn")
var type := 0
var pathArray:Array[String]
func open_dir(dir_name:String):
	print(dir_name)
	var comic_dir
	if dir_name == pathArray[pathArray.size()-2]:
		type -= 1
		pathArray.remove_at(pathArray.size()-1)
		comic_dir = DirAccess.open(pathArray[pathArray.size()-1])
		#print(pathArray[pathArray.size()-1])
		pass
	else:
		type += 1
		pathArray.append(pathArray[pathArray.size()-1] + "/" + dir_name)
		comic_dir = DirAccess.open(pathArray[pathArray.size() - 1])
		print(pathArray[pathArray.size()-1] + "/" + dir_name)
	if type == 0:
		for i in move_book_con.get_child(0).get_children():
			if i.name == "搜索":
				continue
			if i.comic_name != dir_name:
				i.queue_free()
		move_book_con.get_parent().set_visible(false)
		return
	if comic_dir :
		for i in move_book_con.get_child(0).get_children():
			if i.name == "搜索":
				continue
			if i.comic_name != dir_name:
				i.queue_free()
		print("打开成功")	
		comic_dir.list_dir_begin()
		var file_name = comic_dir.get_next()
		while file_name != "":
			if comic_dir.current_is_dir():
				print("发现目录：" + file_name)
				var add_book = book_con.instantiate()
				#书籍名称归档
				add_book.comic_name = file_name
				add_book.type = type
				add_book.set_head()
				move_book_con.get_child(0).add_child(add_book)
			else:			
				#防止文件不对应
				if not file_name.ends_with(comic_end_with):
					continue
				file_name = back_file_name(file_name)
				print("发现文件：" + file_name)
				#此处开始添加书籍
				var add_book = book.instantiate()
				#书籍名称归档
				add_book.comic_name = file_name
				add_book.set_head()
				move_book_con.get_child(0).add_child(add_book)
				#全局变量储存
				var temp_array:Array
				comic[file_name] = temp_array	
			file_name = comic_dir.get_next()
		var add_book = book_con.instantiate()	
		add_book.comic_name = pathArray[pathArray.size()-2]
		add_book.type = type
		add_book.set_head()
		move_book_con.get_child(0).add_child(add_book)
		add_book.get_parent().move_child(add_book,1)
		
		move_book_con.get_parent().set_visible(true)
#返回文件名称,不含有后缀
func back_file_name(file_name:String):
	return file_name.rstrip("." + comic_end_with)
