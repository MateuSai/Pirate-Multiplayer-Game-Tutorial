extends VBoxContainer


func add_player(name: String) -> void:
	var label: Label = Label.new()
	label.text = name
	add_child(label)
	
	
func remove_player(index: int) -> void:
	get_child(index).queue_free()
	
	
func remove_all() -> void:
	for child in get_children():
		child.queue_free()
