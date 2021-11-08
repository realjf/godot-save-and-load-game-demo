extends Control


onready var vbox = $ScrollContainer/VBoxContainer

var selected: RichTextLabel = null


func _on_ExitButton_pressed():
	queue_free()
	
func _process(delta):
	var records = vbox.get_children()
	for r in records:
		var n = r.get_node("RichTextLabel").has_focus()
		if n:
			selected = r.get_node("RichTextLabel")


func _on_LoadButton_pressed():
	print("loading: " + selected.bbcode_text)
	pass
	
