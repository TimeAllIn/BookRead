extends Panel

@export var comic_name:String
@export var now_page:int = 0

var drag = false
var drag_from
var is_move := false

var move_delta:float = 0
func 滑动(event: InputEvent) -> void:
	if event is InputEventMouseButton:  
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:  
			# 鼠标左键按下时记录鼠标位置和标记开始拖动  
			drag = true  
			drag_from = get_global_mouse_position() 
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and drag:  
			# 鼠标左键释放时结束拖动  
			drag = false 
	if drag and event is InputEventMouseMotion:  
		# 如果正在拖动，更新控件的位置 
		var new_pos = get_global_mouse_position()   
		move_delta = (new_pos - drag_from).y * Data.speed
		if abs(move_delta) > 1:
			is_move = true
		drag_from = new_pos
		if get_parent().name != "目录":
			Data.move_book.set_v_scroll(Data.move_book.get_v_scroll() - int(move_delta))
		else:
			Data.move_book_con.set_v_scroll(Data.move_book_con.get_v_scroll() - int(move_delta))
	pass
func _on_按钮_button_up() -> void:
	is_move = false
	pass
#添加图书的线程
var thread:Thread

#初次漫画设置
var start_read:bool = false
#这个为true标准全部导入
var end_read:bool = false

func 按下按钮() -> void:
	if is_move:
		return
	#漫画最少五张
	Data.now_look = self
	if get_parent().name == "容器":
		get_parent().move_child(self,0)
	else:
		get_parent().move_child(self,1)
	Data.comic_show.now_page = now_page
	start_read = true
	thread = Thread.new()
	thread.start(load_comic)
	pass

func set_head():
	$"文本".set_text(comic_name)

func _physics_process(delta: float) -> void:
	if start_read:
		if Data.comic_name_to(comic_name).size() >= now_page + 5 or end_read:
			print(end_read)
			Data.comic_show.open_read()
			start_read = false
	if end_read:
		end_read = false
	
	#滑动	
	if move_delta != 0 and not drag:
		if abs(move_delta) <= 3:
			move_delta = 0
			return
		move_delta = lerpf(0,move_delta,0.98)
		if get_parent().name != "目录":
			Data.move_book.set_v_scroll(Data.move_book.get_v_scroll() - int(move_delta))
		else:
			Data.move_book_con.set_v_scroll(Data.move_book_con.get_v_scroll() - int(move_delta))
	pass
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
	var err := reader.open(Data.pathArray[Data.type] + "/" + file_name)
	print(err)
	if err == OK:
		var key = reader.read_file("key.br")
		#图书类型获取
		book_key = key.get_string_from_utf8()
		print(book_key)	
		if book_key=="jpg":
			var start_num:int = 1
			#print("book("+str(start_num) + ")." +  book_key)
			var book = reader.read_file("book("+str(start_num) + ")." + Data.comic_end_with)
			while not book.is_empty():		
				#print("book ("+str(start_num) + ")." +  book_key)
				var book_image:Image = Image.new()
				book_image.load_jpg_from_buffer(book)
				Data.comic_name_to(comic_name).append(ImageTexture.create_from_image(book_image))				
				start_num += 1
				book = reader.read_file("book("+str(start_num) + ")." + Data.comic_end_with)
		elif book_key == "png":
			var start_num:int = 1
			#print("book("+str(start_num) + ")." +  book_key)
			var book = reader.read_file("book("+str(start_num) + ")." + Data.comic_end_with)
			while not book.is_empty():		
				print("book("+str(start_num) + ")." +  book_key)
				var book_image:Image = Image.new()
				book_image.load_png_from_buffer(book)
				Data.comic_name_to(comic_name).append(ImageTexture.create_from_image(book_image))				
				start_num += 1
				book = reader.read_file("book("+str(start_num) + ")." + Data.comic_end_with)
	reader.close()
	thread.wait_to_finish()
	end_read = true
	pass
