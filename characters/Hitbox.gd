extends Area2D

onready var player: KinematicBody2D = get_parent()


func _on_Hitbox_body_entered(body: Node) -> void:
	if body != player:
		print(body.name + " entered hitbox")
		player.emit_signal("damage", int(body.name), 1)
