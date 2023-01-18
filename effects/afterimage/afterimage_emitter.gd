class_name AfterimageEmitter
extends Node2D

const AFTERIMAGE_SCENE = preload("res://effects/afterimage/afterimage.tscn")

export var emitting := false setget set_emitting
export var interval := 1.0 setget set_interval
export var afterimage_lifetime := 1.0
export var animated_sprite_path : NodePath
onready var animated_sprite : AnimatedSprite = get_node(animated_sprite_path)

func _ready() -> void:
	if emitting:
		$EmitTimer.start(interval)

func _on_EmitTimer_timeout() -> void:
	var afterimage :  Afterimage = AFTERIMAGE_SCENE.instance()
	owner.get_parent().add_child(afterimage)
	afterimage.global_position = global_position
	
	afterimage.sprite_frames = animated_sprite.frames
	afterimage.animation = animated_sprite.animation
	afterimage.frame = animated_sprite.frame
	
	afterimage.time = afterimage_lifetime

func set_emitting(value: bool) -> void:
	emitting = value
	if emitting:
		$EmitTimer.start(interval)
	else:
		$EmitTimer.stop()

func set_interval(value: float) -> void:
	interval = value
	if emitting:
		$EmitTimer.start(interval)
	else:
		$EmitTimer.stop()
