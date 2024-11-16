extends Panel

@onready var 指示器: Panel = $"指示/指示/指示器"
var tween_time:float = 0.05
#子部件按钮合集
var button_list:Array
@export var no_color:Color
@export var focus_color:Color
func _ready() -> void:
	漫画按钮()
	pass

func 漫画按钮() -> void:

	$"../分区界面/漫画区".set_visible(true)
	$"../分区界面/设置区".set_visible(false)
	$"../分区界面/个人区".set_visible(false)
	$"容器/漫画区".set_modulate(focus_color)
	$"容器/设置区".set_modulate(no_color)
	$"容器/个人区".set_modulate(no_color)
	pass
func 添加按钮() -> void:

	$"../分区界面/漫画区".set_visible(false)
	$"../分区界面/设置区".set_visible(true)
	$"../分区界面/个人区".set_visible(false)
	$"容器/漫画区".set_modulate(no_color)
	$"容器/设置区".set_modulate(focus_color)
	$"容器/个人区".set_modulate(no_color)
	
	pass
func 个人按钮() -> void:

	$"../分区界面/漫画区".set_visible(false)
	$"../分区界面/设置区".set_visible(false)
	$"../分区界面/个人区".set_visible(true)
	$"容器/漫画区".set_modulate(no_color)
	$"容器/设置区".set_modulate(no_color)
	$"容器/个人区".set_modulate(focus_color)
	pass
