extends Control

signal fade_to_black_finished()

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "on_animation_finished")

func fade_transition() -> void:
	$AnimationPlayer.play("fade_to_black")
	
func fade_in() -> void:
	$AnimationPlayer.play("fade_to_normal")

func on_animation_finished(anim_name) -> void:
	if anim_name == "fade_to_black":
		emit_signal("fade_to_black_finished")
		$AnimationPlayer.play("fade_to_normal")
