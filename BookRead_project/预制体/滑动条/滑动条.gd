extends Panel

var drag = false
var drag_from
var is_move := false

var move_delta:float = 0

signal value_change(value:float)

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
		move_delta = (new_pos - drag_from).x * Data.speed
		drag_from = new_pos
		$"移动条".position.x += move_delta
		if $"移动条".position.x < 0:
			$"移动条".position.x = 0
		elif $"移动条".position.x > size.x - $"移动条".size.x:
			$"移动条".position.x = size.x - $"移动条".size.x
		$"跟随条".size.x = $"移动条".position.x + $"移动条".size.x
		
		value = $"移动条".position.x/(size.x - $"移动条".size.x)
		value_change.emit(value)
		
	pass
@export var value:float

func _ready() -> void:
	set_value(value)

func set_value(temp_value:float):
	value = temp_value
	$"移动条".position.x = (size.x - $"移动条".size.x) * value
	$"跟随条".size.x = $"移动条".position.x + $"移动条".size.x
