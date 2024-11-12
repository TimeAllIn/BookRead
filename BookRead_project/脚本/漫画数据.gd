extends Panel

@export var comic_name:String
@export var now_page:int = 0

#添加图书的线程
var thread:Thread

#初次漫画设置
var start_read:bool = false
#这个为true标准全部导入
var end_read:bool = false

func 按下按钮() -> void:
	#漫画最少五张
	Data.now_look = self
	
	Data.comic_show.now_page = now_page
	#print(Data.comic_show.now_page)
	get_parent().move_child(self,0)
	if Data.comic_name_to(comic_name).size() <= 5:
		Data.comic_show.now_page = 0
		start_read = true
		thread =Thread.new()
		thread.start(load_comic)
		
		return	
	Data.comic_show.open_read()
	pass

func set_head():
	$"文本".set_text(comic_name)

func _physics_process(delta: float) -> void:
	if start_read:
		if Data.comic_name_to(comic_name).size() >= now_page + 5 or end_read:
			Data.comic_show.open_read()
			start_read = false
			
#添加图书
func load_comic():
	#图书类型
	var book_key:String = ""
	#图书读取
	var reader := ZIPReader.new()
	#图书全称
	var file_name = comic_name + "." + Data.comic_end_with
	var book_comic:Array
	#数组归档
	Data.comic[comic_name] = book_comic
	var err := reader.open(Data.comic_path + "/" + file_name)
	if err == OK:
		var key = reader.read_file("key.br")
		#图书类型获取
		book_key = key.get_string_from_utf8()
		#print(book_key)	
		if book_key=="jpg":
			var start_num:int = 1
			#print("book("+str(start_num) + ")." +  book_key)
			var book = reader.read_file("book("+str(start_num) + ")." +  book_key)
			while not book.is_empty():		
				#print("book ("+str(start_num) + ")." +  book_key)
				var book_image:Image = Image.new()
				book_image.load_jpg_from_buffer(book)
				Data.comic_name_to(comic_name).append(ImageTexture.create_from_image(book_image))				
				start_num += 1
				book = reader.read_file("book("+str(start_num) + ")." +  book_key)
		elif book_key == "png":
			var start_num:int = 1
			#print("book("+str(start_num) + ")." +  book_key)
			var book = reader.read_file("book("+str(start_num) + ")." +  book_key)
			while not book.is_empty():		
				#print("book("+str(start_num) + ")." +  book_key)
				var book_image:Image = Image.new()
				book_image.load_png_from_buffer(book)
				Data.comic_name_to(comic_name).append(ImageTexture.create_from_image(book_image))				
				start_num += 1
				book = reader.read_file("book("+str(start_num) + ")." +  book_key)
	reader.close()
	thread.wait_to_finish()
	end_read = true
	pass
