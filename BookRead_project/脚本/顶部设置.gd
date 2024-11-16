extends Panel

var my_array:Array

func 搜索提交(new_text: String) -> void:
	if new_text == "":
		if my_array.size() != 0:
			for i in get_parent().get_children():
				if i.name == name:
					continue
				for num in range(my_array.size()):
					if i == my_array[num]:
						i.get_parent().move_child(i,num + 1)
			my_array.clear()
			return
	my_array = get_parent().get_children()
	my_array.erase(self)
	
	var temp_array:Array = Array(my_array)
	test_string = new_text
	temp_array.sort_custom(sort_ascending)
	for i in range(temp_array.size()):
		temp_array[i].get_parent().move_child(temp_array[i],i + 1)
	pass

var test_string:String
func sort_ascending(a, b):
	return not a.comic_name.similarity(test_string) < b.comic_name.similarity(test_string)
