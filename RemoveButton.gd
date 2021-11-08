extends Button


func _on_RemoveButton_pressed():
	var dir = Directory.new()
	var select = get_parent().selected
	var path = get_parent().loadDir
	if select:
		var bbcodetext = select.bbcode_text
		var textArr = bbcodetext.split("\t")
		print(path + textArr[0] + get_parent().file_extension)
		if dir.remove(path + textArr[0] + get_parent().file_extension) == OK:
			get_parent().vbox.remove_child(select.get_parent())
			print("remove file:" + textArr[0])
		else:
			print("failed to remove file: " + textArr[0])
	else:
		print("please select a file to delete")
