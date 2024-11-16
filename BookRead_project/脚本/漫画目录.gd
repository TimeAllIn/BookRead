extends Panel

@export var comic_name:String



var drag = false
var drag_from
var is_move := false
var move_delta:float = 0
@export var type:int = 0


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
		if type == 0:
			Data.move_book.set_v_scroll(Data.move_book.get_v_scroll() - int(move_delta))
		else :
			Data.move_book_con.set_v_scroll(Data.move_book_con.get_v_scroll() - int(move_delta))
	pass
func _on_按钮_button_up() -> void:
	is_move = false
	set_self_modulate(Color(1,1,1))
	pass

func 按下按钮() -> void:
	if is_move:
		return
	Data.open_dir(comic_name)
	if type != 0:
		queue_free()
	else:
		get_parent().move_child(self,1)
	pass


func set_head():
	$"文本".set_text("目录:"+comic_name)

func _physics_process(delta: float) -> void:
	#滑动	
	if move_delta != 0 and not drag:
		if abs(move_delta) <= 3:
			move_delta = 0
			return
		move_delta = lerpf(0,move_delta,0.98)
		if type == 0:
			Data.move_book.set_v_scroll(Data.move_book.get_v_scroll() - int(move_delta))
		else :
			Data.move_book_con.set_v_scroll(Data.move_book_con.get_v_scroll() - int(move_delta))
	pass


func 按下() -> void:
	set_self_modulate(Color(0.8,0.8,0.8))
	pass # Replace with function body.
func back_name():
	return "目录:"+comic_name
