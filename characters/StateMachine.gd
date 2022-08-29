extends Node

enum {
	IDLE,
	RUN,
	ATTACK,
	DEAD
}

var state: int = -1 setget set_state

onready var player: KinematicBody2D = get_parent()

onready var revive_timer: Timer = player.get_node("ReviveTimer")


func _physics_process(_delta: float) -> void:
	var transition: int = _get_transition()
	if transition != -1:
		set_state(transition)


func _get_transition() -> int:
	match state:
		IDLE:
			if player.velocity.length() > 5:
				return RUN
		RUN:
			if player.velocity.length() < 5:
				return IDLE
		ATTACK:
			if not player.animation_player.is_playing():
				return IDLE
		DEAD:
			if revive_timer.is_stopped():
				return IDLE
				
	return -1
	
	
func _enter_state(new_state: int) -> void:
	match new_state:
		IDLE:
			player.animation_player.play("idle")
		RUN:
			player.animation_player.play("run")
		ATTACK:
			player.animation_player.play("attack")
		DEAD:
			player.can_move = false
			player.animation_player.play("dead")
			revive_timer.start()
			
			
func _exit_state(state_exited: int) -> void:
	match state_exited:
		DEAD:
			player.hp = 2
			player.can_move = true
			
			
func set_state(new_state: int) -> void:
	if state != new_state:
		_exit_state(state)
		state = new_state
		_enter_state(new_state)
