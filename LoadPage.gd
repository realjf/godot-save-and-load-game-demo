extends Control

# online need change directory to user://
var loadDir = "res://loadDir/"
var files = []
onready var vbox = $ScrollContainer/VBoxContainer
export(String, FILE) var recordItem = ""
export(String, FILE) var styleBox = ""
var normal_style = null
var file_extension = ".save"
var flush = false

var selected: RichTextLabel = null


func _ready():
	dir_contents(loadDir)
	load_files()


func load_files():
	clear_all_child()
	if len(files) > 0:
		for r in files:
			var record = load(recordItem).instance()
			record.get_node("RichTextLabel").bbcode_text = r.name + "\t" + r.datetime
			vbox.add_child(record)

func clear_all_child():
	for i in vbox.get_children():
		vbox.remove_child(i)
		

func dir_contents(path):
	files = []
	var dir = Directory.new()
	if !dir.dir_exists(loadDir):
		if dir.make_dir_recursive(loadDir) == OK:
			print("make dir " + loadDir + " successfully")
		else:
			print("make dir " + loadDir + " error")
			return
		
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("found directory: " + file_name)
			else:
				var file = File.new()
				if file.open(path + file_name, File.READ) == OK:
					var time = OS.get_datetime_from_unix_time(file.get_modified_time(path + file_name))
					var datetime = _format_time(time)
					var f = {
						"name": file_name.get_basename(),
						"datetime": datetime,
					}
					print(f)
					files.append(f)
				else:
					print("failed to read file: " + path + file_name)
				
			file_name = dir.get_next()
	else:
		print("failed to open dir: " + path)


func _format_time(time: Dictionary):
	var date = String(time.get("year")) + "-" + \
	String(time.get("month")) + "-" + \
	String(time.get("day")) + " "
	if time.get("hour") < 10:
		date += "0" + String(time.get("hour")) + ":"
	else:
		date += String(time.get("hour")) + ":"
	if time.get("minute") < 10:
		date += "0" + String(time.get("minute")) + ":"
	else:
		date += String(time.get("minute")) + ":"
	if time.get("second") < 10:
		date += "0" + String(time.get("second"))
	else:
		date += String(time.get("second"))

	return date

func _on_ExitButton_pressed():
	queue_free()
	
func _process(delta):
	dir_contents(loadDir)
	load_files()
	var records = vbox.get_children()
	for r in records:
		var n = r.get_node("RichTextLabel").has_focus()
		if n:
			if selected:
				selected.add_stylebox_override("normal", normal_style)
			selected = r.get_node("RichTextLabel")
			var new_style = load(styleBox)
			normal_style = selected.get_stylebox("normal")
			selected.add_stylebox_override("normal", new_style)

	if visible and !flush:
		dir_contents(loadDir)
		load_files()
		flush = true

func _on_LoadButton_pressed():
	var bbcodetext = selected.bbcode_text
	var textArr = bbcodetext.split("\t")
	print("loading: " + textArr[0] + " " + textArr[1])
	print("file_path: " + loadDir + textArr[0] + file_extension)
	pass
	


func _on_LoadPage_visibility_changed():
	flush = false
