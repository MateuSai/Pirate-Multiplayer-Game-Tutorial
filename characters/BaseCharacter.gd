extends KinematicBody2D
class_name BaseCharacter

var hp: int = 2 setget set_hp

onready var sprite: Sprite = get_node("Sprite")
onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
onready var name_label: Label = get_node("Label")


func initialize(id: int, name: String, character_index: int) -> void:
	self.name = str(id)
	
	name_label.text = name
	
	var character_height: float = sprite.texture.get_height() / 4.0
	sprite.region_rect = Rect2(0, character_height * character_index, sprite.texture.get_width(), character_height)


func damage(dam: int) -> void:
	self.hp -= dam
	
	
func enable_hitbox() -> void:
	pass
	
	
func disable_hitbox() -> void:
	pass


func die() -> void:
	pass


func set_hp(new_hp: int) -> void:
	hp = new_hp
	print("new hp is " + str(hp))
	if hp <= 0:
		die()
