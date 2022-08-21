extends BaseCharacter

const GRAVITY: int = 200
const FRICTION: float = 0.1
const ACCELERATION: float = 0.25

var speed: int = 50
var dir: float
var jump_impulse: int = -85

var velocity: Vector2 = Vector2.ZERO

var can_move: bool = true setget set_can_move

signal position_changed(new_pos)
signal flip_h_changed(flip_h)
signal animation_changed(anim_name)

onready var state_machine: Node = get_node("StateMachine")
onready var hitbox_col: CollisionShape2D = get_node("Hitbox/CollisionShape2D")


func _ready() -> void:
    state_machine.set_state(state_machine.IDLE)


func _get_input() -> void:
    dir = Input.get_axis("ui_left", "ui_right")
    if dir != 0:
        if (dir > 0 and sprite.flip_h) or (dir < 0 and not sprite.flip_h):
            _flip()
        velocity.x = lerp(velocity.x, dir * speed, ACCELERATION)
        
    if Input.is_action_just_pressed("ui_jump") and Input.is_action_pressed("ui_down"):
        set_collision_mask_bit(1, false)
    elif Input.is_action_just_pressed("ui_jump") and is_on_floor():
            velocity.y = jump_impulse
            
    if Input.is_action_just_released("ui_jump") and not get_collision_mask_bit(1):
        set_collision_mask_bit(1, true)
        
    if Input.is_action_just_pressed("ui_attack"):
        state_machine.set_state(state_machine.ATTACK)
        
        
func _physics_process(delta: float) -> void:
    if can_move:
        _get_input()
        
    velocity.y += GRAVITY * delta
    velocity = move_and_slide(velocity, Vector2.UP)
    if dir == 0:
        velocity.x = lerp(velocity.x, 0, FRICTION)
        
    emit_signal("position_changed", position)


func _flip() -> void:
    sprite.flip_h = not sprite.flip_h
    hitbox_col.position.x *= -1
    emit_signal("flip_h_changed", sprite.flip_h)


func enable_hitbox() -> void:
    hitbox_col.disabled = false
    
    
func disable_hitbox() -> void:
    hitbox_col.disabled = true


func set_can_move(new_value: bool) -> void:
    can_move = new_value
    if not can_move:
        dir = 0.0


func _on_AnimationPlayer_animation_started(anim_name: String) -> void:
    emit_signal("animation_changed", anim_name)
