extends WindowDialog

onready var connect_container: VBoxContainer = get_node("ConnectVBoxContainer")
onready var error_label: Label = get_node("ConnectVBoxContainer/ErrorLabel")
onready var spin_box: SpinBox = connect_container.get_node("SpinBox")
onready var connect_button: Button = connect_container.get_node("ConnectButton")

onready var wait_container: ScrollContainer = get_node("WaitScrollContainer")
onready var room_label: Label = wait_container.get_node("VBoxContainer/Label")


func _on_ConnectButton_pressed() -> void:
    connect_button.disabled = true
    
    # warning-ignore:narrowing_conversion
    Client.connect_to_server(spin_box.value)


func connected_ok() -> void:
    connect_container.hide()
    connect_button.disabled = false
    
    wait_container.show()


func _on_JoinDialog_popup_hide() -> void:
    wait_container.hide()
    connect_container.show()
