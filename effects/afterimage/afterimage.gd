class_name Afterimage
extends Node2D

var sprite_frames : SpriteFrames setget set_sprite_frame
var animation : String setget set_animation
var frame : int setget set_frame

var time := 1.0 setget set_time

func _process(_delta: float) -> void:
	modulate.a = $Timer.time_left/time

func _on_Timer_timeout() -> void:
	queue_free()

func set_sprite_frame(value: SpriteFrames) -> void:
	sprite_frames = value
	$AnimatedSprite.frames = sprite_frames

func set_animation(value: String) -> void:
	animation = value
	$AnimatedSprite.animation = animation

func set_frame(value: int) -> void:
	frame = value
	$AnimatedSprite.frame = frame

func set_time(value: float) -> void:
	time = value
	$Timer.start(time)
