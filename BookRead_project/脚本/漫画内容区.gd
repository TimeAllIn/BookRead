extends Panel

@export var comic_array:Array
@export var comic_min:Vector2

@export var now_page:int

func open_read():
	if now_page < 6:
		for i in $"容器/容器".get_child_count():
			$"容器/容器".get_child(i).set_texture(i)
			$"容器/容器".get_child(i).set_custom_minimum_size(comic_min)
		$"../../容器".set_v_scroll(int(now_page * comic_min.y))
	else:
		for i in $"容器/容器".get_child_count():
			if now_page + i - 6 >= comic_array.size():
				break
			$"容器/容器".get_child(i).set_texture(now_page + i - 6)
			$"容器/容器".get_child(i).set_custom_minimum_size(comic_min)
		$"../../容器".set_v_scroll(int(7 * comic_min.y))
		pass
#
#for i in 18:
		#var num = i + 1
		#var path = "res://测试/a/Ethernet Cable Girlfriend conv"+" "+ str(num)+".png"
		#var image = Image.load_from_file(path)
		#var texture = ImageTexture.create_from_image(image)
		#$"容器/容器/漫画内容".set_texture(texture)
		#
		#texture_array.append(texture)
#
	#var file = save_data.new()
	#file.comic = texture_array
	#ResourceSaver.save(file,"user://re.res")
	#load_comic()
#func load_comic():
	#var file = ResourceLoader.load("user://re.res") as save_data
	#texture_array = file.comic
	#$"容器/容器/漫画内容".set_texture(texture_array[15])
