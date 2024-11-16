extends Panel

##书籍配置
##漫画名称
@export var comic_name:String
##当前浏览的页数
@export var now_page:int = 0

#region 拖动配置
##拖动配置
#是否是拖动状态
var drag = false
#拖动的初始位置
var drag_from
#是否可以点击按钮
var is_move := false
#拖动移动的变量
var move_delta:float = 0
##处理整个拖动事件
#处理滑动相关事件
func 滑动(event: InputEvent) -> void:
	if event is InputEventMouseButton:  
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:   
			drag = true  
			drag_from = get_global_mouse_position() 
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and drag:  
			drag = false 
	if drag and event is InputEventMouseMotion:  
		var new_pos = get_global_mouse_position()   
		move_delta = (new_pos - drag_from).y * Data.speed
		if abs(move_delta) > 1:
			is_move = true
		drag_from = new_pos
		#拖动的变值
		if get_parent().name != "目录":
			Data.move_book.set_v_scroll(Data.move_book.get_v_scroll() - int(move_delta))
		else:
			Data.move_book_con.set_v_scroll(Data.move_book_con.get_v_scroll() - int(move_delta))
	pass
#按钮抬起，初始化状态
func 按钮抬起() -> void:
	is_move = false
	set_self_modulate(Color(1,1,1))
	pass
#该函数放在每秒循环函数内处理
func 滑动后速度处理():	
	if move_delta != 0 and not drag:
		if abs(move_delta) <= 3:
			move_delta = 0
			return
		move_delta = lerpf(0,move_delta,0.98)
		if get_parent().name != "目录":
			Data.move_book.set_v_scroll(Data.move_book.get_v_scroll() - int(move_delta))
		else:
			Data.move_book_con.set_v_scroll(Data.move_book_con.get_v_scroll() - int(move_delta))
#endregion
#region 添加书籍附加点击
#添加图书的线程
var thread:Thread
#初次漫画设置
var start_read:bool = false
#这个为true标准全部导入
var end_read:bool = false

func 按下按钮() -> void:
	if is_move:
		return
	Data.now_look = self
	if get_parent().name == "目录":
		get_parent().move_child(self,2)
	else:
		get_parent().move_child(self,1)
	Data.comic_show.now_page = now_page
	start_read = true
	thread = Thread.new()
	thread.start(load_comic)
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
#这个函数确保可以进行阅读
func 开始阅读():
	if start_read:
		if Data.comic_name_to(comic_name).size() >= now_page + 5 or end_read:
			Data.comic_show.open_read()
			start_read = false
	if end_read:
		end_read = false
#endregion
#设置标题
var load_image
func set_head():
	$"名称".set_text(comic_name)
	#使用线程，避免卡顿
	thread = Thread.new()
	thread.start(封面设置)
	
#封面设置()
func 封面设置():
	var book_key:String = ""
	#图书读取
	var reader := ZIPReader.new()
	#图书全称
	var file_name = comic_name + "." + Data.comic_end_with
	var err := reader.open(Data.pathArray[Data.type] + "/" + file_name)
	var start_num:int = 1
	var book_image:Image = Image.new()
	if err == OK:
		var key = reader.read_file("key.br")
		book_key = key.get_string_from_utf8()
		if book_key=="jpg":
			var book = reader.read_file("book("+str(start_num)+")." + Data.comic_end_with)		
			book_image.load_jpg_from_buffer(book)
			while book_image == null:
				start_num += 1
				book = reader.read_file("book("+str(start_num)+")." + Data.comic_end_with)
				book_image.load_jpg_from_buffer(book)
		elif book_key=="png":
			var book = reader.read_file("book(1)." + Data.comic_end_with)
			book_image.load_png_from_buffer(book)
			while book_image == null:
				start_num += 1
				book = reader.read_file("book("+str(start_num)+")." + Data.comic_end_with)
				book_image.load_png_from_buffer(book)
		load_image = ImageTexture.create_from_image(book_image)
	thread.wait_to_finish()
	pass
func 封面处理及其他后处理():
	if $"封面".get_texture() != load_image:
		$"封面".set_texture(load_image)
	if $"页数".text != "阅读到"+str(now_page)+"页":
		$"页数".text = "阅读到"+str(now_page)+"页"

func _physics_process(delta: float) -> void:
	封面处理及其他后处理()
	开始阅读()
	滑动后速度处理()
	pass


func 按下() -> void:
	set_self_modulate(Color(0.8,0.8,0.8))
	pass # Replace with function body.

func back_name():
	return comic_name
