extends WindowDialog

const NUM_CHARACTERS: int = 4
var character_index: int = 0 setget set_character_index

onready var character_texture: TextureRect = get_node("VBoxContainer/HBoxContainer/TextureRect")
onready var name_line_edit: LineEdit = get_node("VBoxContainer/LineEdit")


func set_character_index(new_index: int) -> void:
	if new_index < 0:
		character_index = NUM_CHARACTERS - 1
	elif new_index >= NUM_CHARACTERS:
		character_index = 0
	else:
		character_index = new_index
		
	character_texture.texture = load("res://assets/images/GhostShip_Assets/character_icons/character" + str(character_index) + ".png")


func _on_LeftButton_pressed() -> void:
	self.character_index -= 1


func _on_RightButton_pressed() -> void:
	self.character_index += 1


func _on_CharacterSelector_about_to_show() -> void:
	self.character_index = Client.my_info.character_index
	name_line_edit.text = Client.my_info.name


func _on_CharacterSelector_popup_hide() -> void:
	Client.my_info.character_index = character_index
	Client.my_info.name = name_line_edit.text
