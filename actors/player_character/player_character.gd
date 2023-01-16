extends KinematicBody2D

export var Speed := 500

var _sprites := {Vector2.RIGHT: 1, Vector2.LEFT: 3, Vector2.UP: 2, Vector2.DOWN: 0}
var _velocity := Vector2.ZERO

onready var animated_sprite: AnimatedSprite = $PlayerSprite

func _physics_process(delta: float) -> void:
	var direction := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	# if we have 8 direction movement we need to normalize
	if direction.length() > 1.0:
		direction = direction.normalized()

	move_and_slide(Speed * direction)


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
	animated_sprite.frame = _sprites[direction]
