extends Panel

var drag = false
var drag_from
@export var move_scrool:ScrollContainer
var move_delta:float = 0
func _physics_process(delta: float) -> void:
	if move_delta != 0 and not drag:
		if abs(move_delta) <= 3:
			move_delta = 0
			return
		move_delta = lerpf(0,move_delta,0.98)
		move_scrool.set_v_scroll(move_scrool.get_v_scroll() - int(move_delta))
	pass

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
		drag_from = new_pos
		move_scrool.set_v_scroll(move_scrool.get_v_scroll() - int(move_delta))
			
	pass
