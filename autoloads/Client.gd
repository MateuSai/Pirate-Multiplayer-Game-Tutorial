extends Node

const SERVER_ADDRESS: String = "127.0.0.1"
const SERVER_PORT: int = 5466

var my_info: Dictionary = {
    name = "Elizabeth",
    character_index = 0,
    instance = null,
}

var player_info: Dictionary = {}

var is_creator: bool = false

var room: int


func create_room() -> void:
    is_creator = true
    connect_to_server()


func connect_to_server(room_id: int = 0) -> void:
    room = room_id
    
    var peer: NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
    if peer.create_client(SERVER_ADDRESS, SERVER_PORT):
        printerr("Error creating the client")
    get_tree().network_peer = peer
    
    if get_tree().connect("connected_to_server", self, "_connected_ok"):
        printerr("Failed to connect connected_server")
    if get_tree().connect("connection_failed", self, "_connected_fail"):
        printerr("Failed to connect connection_failed")
    if get_tree().connect("server_disconnected", self, "_server_disconnected"):
        printerr("Failed to connect server_diconnected")
        
        
func stop() -> void:
    print("Disconnecting from server")
    
    get_tree().disconnect("connected_to_server", self, "_connected_ok")
    get_tree().disconnect("connection_failed", self, "_connected_fail")
    get_tree().disconnect("server_disconnected", self, "_server_disconnected")
    
    get_tree().network_peer = null


func _connected_ok() -> void:
    print("Connected to server!")
    if is_creator:
        rpc_id(1, "create_room", my_info)
    else:
        rpc_id(1, "join_room", room, my_info)
    
    
func _connected_fail() -> void:
    print("Connection to server failed!!")
    
    
func _server_disconnected() -> void:
    print("Server disconnected!")


remote func update_room(room_id: int) -> void:
    if get_tree().current_scene.name == "Menu":
        get_tree().current_scene.update_room(room_id)
