extends Control


onready var create_dialog: AcceptDialog = get_node("CreateDialog")
onready var create_dialog_label: Label = create_dialog.get_node("ScrollContainer/VBoxContainer/Label")
onready var create_dialog_player_list: VBoxContainer = create_dialog.get_node("ScrollContainer/VBoxContainer/PlayerList")

onready var join_dialog: WindowDialog = get_node("JoinDialog")
onready var join_room_label: Label = join_dialog.get_node("WaitScrollContainer/VBoxContainer/Label")
onready var join_player_list: VBoxContainer = join_dialog.get_node("WaitScrollContainer/VBoxContainer/PlayerList")


func update_room(room_id: int) -> void:
    if Client.is_creator:
        create_dialog_label.text = "Room id: " + str(room_id)
    else:
        join_room_label.text = "Room id: " + str(room_id)
        join_dialog.connected_ok()


func _on_CreateButton_pressed() -> void:
    Client.create_room()
    create_dialog.popup_centered()
    
    
func _on_JoinButton_pressed() -> void:
    join_dialog.popup_centered()


func _on_popup_hide() -> void:
    if get_tree().network_peer != null:
        Client.stop()
