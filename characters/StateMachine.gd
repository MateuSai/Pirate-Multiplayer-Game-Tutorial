extends Node

enum {
    IDLE,
    RUN,
    ATTACK,
    DEAD
}

var state: int = -1 setget set_state

onready var player: KinematicBody2D = get_parent()


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
            
            
func set_state(new_state: int) -> void:
    if state != new_state:
        state = new_state
        _enter_state(new_state)
