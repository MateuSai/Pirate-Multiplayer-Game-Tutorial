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
    
    if get_tree().connect("connected_to_server", self, "_connected_ok", [], CONNECT_DEFERRED):
        printerr("Failed to connect connected_server")
    if get_tree().connect("connection_failed", self, "_connected_fail", [], CONNECT_DEFERRED):
        printerr("Failed to connect connection_failed")
    if get_tree().connect("server_disconnected", self, "_server_disconnected", [], CONNECT_DEFERRED):
        printerr("Failed to connect server_diconnected")
        
        
func stop() -> void:
    print("Disconnecting from server")
    
    get_tree().disconnect("connected_to_server", self, "_connected_ok")
    get_tree().disconnect("connection_failed", self, "_connected_fail")
    get_tree().disconnect("server_disconnected", self, "_server_disconnected")
    
    get_tree().network_peer = null
    
    _remove_all_players()
    
    
remote func register_player(id: int, info: Dictionary) -> void:
    player_info[id] = info
    get_tree().current_scene.add_player_to_ui(info.name)
    
    
func start_game() -> void:
    rpc_id(1, "start_game")
    
    
remote func pre_configure_game() -> void:
    print("pre_configure_game called")
    
    # Avoids closing the server when the popup_hide signal of the popups is sent
    get_tree().current_scene.set_deferred("game_started", true)
    
    get_tree().paused = true
    
    get_tree().current_scene.queue_free()
    var game: Node2D = preload("res://Game.tscn").instance()
    get_tree().root.add_child(game)
    get_tree().current_scene = game
    
    var my_player: KinematicBody2D = preload("res://characters/Player.tscn").instance()
    game.add_child(my_player)
    player_info[get_tree().get_network_unique_id()].instance = my_player
    
    if my_player.connect("position_changed", self, "_on_position_changed"):
        printerr("Error connecting position_changed signal")
    if my_player.connect("flip_h_changed", self, "_on_flip_h_changed"):
        printerr("Error connecting flip_h_changed signal")
    if my_player.connect("animation_changed", self, "_on_animation_changed"):
        printerr("Error connecting animation_changed signal")
    
    for player_id in player_info:
        if player_id != get_tree().get_network_unique_id():
            var player: KinematicBody2D = preload("res://characters/BaseCharacter.tscn").instance()
            game.add_child(player)
            player_info[player_id].instance = player
            
    rpc_id(1, "done_preconfiguring")
    
    
remote func done_preconfiguring() -> void:
    get_tree().paused = false
    
    
func _on_position_changed(new_pos: Vector2) -> void:
    rpc_unreliable_id(1, "change_player_pos", new_pos)
    
    
func _on_flip_h_changed(flip_h: bool) -> void:
    rpc_id(1, "change_player_flip_h", flip_h)
    
    
func _on_animation_changed(anim_name: String) -> void:
    rpc_id(1, "change_player_anim", anim_name)
    
    
remote func update_player_pos(id: int, pos: Vector2) -> void:
    player_info[id].instance.position = pos
    
    
remote func update_player_flip_h(id: int, flip_h: bool) -> void:
    player_info[id].instance.sprite.flip_h = flip_h
    
    
remote func update_player_anim(id: int, anim_name: String) -> void:
    player_info[id].instance.animation_player.play(anim_name)
    
    
remote func remove_player(id: int) -> void:
    if get_tree().current_scene.name == "Menu":
        # Remove it from the UI
        get_tree().current_scene.remove_player(player_info.keys().find(id))
    else:
        # Remove his instance from the game
        player_info[id].instance.queue_free()
    
    if not player_info.erase(id):
        printerr("Error removing player from dictionary")
        
        
func _remove_all_players() -> void:
    if get_tree().current_scene.name == "Menu":
        # Remove all players from the UI
        get_tree().current_scene.remove_all_players()
    else:
        # We are in game, remove all player instances
        for player_id in player_info:
            player_info[player_id].instance.queue_free()
    
    player_info = {}


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
    stop()


remote func update_room(room_id: int) -> void:
    if get_tree().current_scene.name == "Menu":
        get_tree().current_scene.update_room(room_id)
