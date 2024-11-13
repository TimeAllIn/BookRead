extends Node


#"/storage/emulated/0/"
#漫画所在位置
var comic_path:String = "BookRead/comics"

#初始位置
var comic_start_path:String = "user://"
#var comic_start_path:String = "/storage/emulated/0/"

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

func comic_array():
	return comic.get(now_look.comic_name)

func comic_name_to(comic_name):
	return comic.get(comic_name)

func comic_page():
	return now_look.now_page
