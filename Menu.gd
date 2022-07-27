extends Control


onready var create_dialog: AcceptDialog = get_node("CreateDialog")
onready var create_dialog_label: Label = create_dialog.get_node("ScrollContainer/Label")
onready var create_dialog_player_list: VBoxContainer = create_dialog.get_node("ScrollContainer/PlayerList")


func update_room(room_id: int) -> void:
    create_dialog_label.text = "Room id: " + str(room_id)


func _on_CreateButton_pressed() -> void:
    Client.create_room()
    create_dialog.popup_centered()
