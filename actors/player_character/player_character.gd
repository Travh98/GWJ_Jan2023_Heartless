extends KinematicBody2D

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


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("right"):
		_update_sprite(Vector2.RIGHT)
	elif event.is_action_pressed("left"):
		_update_sprite(Vector2.LEFT)
	elif event.is_action_pressed("down"):
		_update_sprite(Vector2.DOWN)
	elif event.is_action_pressed("up"):
		_update_sprite(Vector2.UP)


func _update_sprite(direction: Vector2) -> void:
	animated_sprite.animation = ANIMATION_DIRECTIONS[direction]
