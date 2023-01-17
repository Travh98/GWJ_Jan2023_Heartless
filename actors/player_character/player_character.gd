extends KinematicBody2D
class_name PlayerCharacter

const ANIMATION_DIRECTIONS := {Vector2.RIGHT: "right", Vector2.LEFT: "left", Vector2.UP: "up", Vector2.DOWN: "down"}
const SPEED := 128

var velocity := Vector2.ZERO

onready var animated_sprite: AnimatedSprite = $Sprite

func _physics_process(delta: float) -> void:
	var input_direction := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()

	move_and_slide(SPEED * input_direction)


func _process(delta: float) -> void:
	var mouse_direction := Vector2.ZERO.direction_to(get_local_mouse_position())
	handle_mouse_direction(mouse_direction)


func handle_mouse_direction(mouse_direction: Vector2) -> void:
	if mouse_direction.x > 0.0:
		_update_sprite(Vector2.RIGHT)
	if mouse_direction.x < 0.0:
		_update_sprite(Vector2.LEFT)
	if mouse_direction.y > 0.85:
		_update_sprite(Vector2.DOWN)
	if mouse_direction.y < -0.85:
		_update_sprite(Vector2.UP)


func _update_sprite(direction: Vector2) -> void:
	animated_sprite.animation = ANIMATION_DIRECTIONS[direction]
