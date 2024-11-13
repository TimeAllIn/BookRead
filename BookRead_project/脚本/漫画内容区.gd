extends Panel


@export var comic_min:Vector2
@export var now_page:int

func _ready() -> void:
	Data.comic_show = self
var up_page:int
func open_read():
	set_visible(true)
	var comic_size = Data.comic_array()[0].get_size()
	comic_min = Vector2(0,(comic_size.y * 550)/comic_size.x)
	if now_page <= 2:
		up_page = 0			
	else:
		up_page = now_page - 2	
	for i in $"容器/容器".get_child_count():
		if up_page + i >= Data.comic_array().size():
			break
		$"容器/容器".get_child(i).set_texture(Data.comic_array()[up_page + i])
		$"容器/容器".get_child(i).set_custom_minimum_size(comic_min)
	$"容器".set_v_scroll(int(2 * comic_min.y))
	if now_page <= 2:
		$"容器".set_v_scroll(int(now_page * comic_min.y))
	pass

func _physics_process(delta: float) -> void:
	if is_visible():
		if $"容器".get_v_scroll() < int(comic_min.y):
			if up_page == 0:
				return
			else:
				$"容器".set_v_scroll(int(2 * comic_min.y))
				up_page -= 1
				for i in $"容器/容器".get_child_count():
					if up_page + i >= Data.comic_array().size():
						break
					$"容器/容器".get_child(i).set_texture(Data.comic_array()[up_page + i])					
				pass	
			pass
		elif $"容器".get_v_scroll() > int(3 * comic_min.y):
			if up_page == Data.comic_array().size() - 5:
				return
			else:
				$"容器".set_v_scroll(int(2 * comic_min.y))
				up_page += 1
				for i in $"容器/容器".get_child_count():
					if up_page + i >= Data.comic_array().size():
						break
					$"容器/容器".get_child(i).set_texture(Data.comic_array()[up_page + i])
				pass
		now_page = up_page + 2
		pass
func 退出阅读() -> void:
	Data.now_look.now_page = now_page
	now_page = 0
	Data.comic_array().clear()
	Data.now_look = null
	$"具体菜单".set_visible(false)
	set_visible(false)
	pass 

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST and is_visible():
		退出阅读()
		pass

	
