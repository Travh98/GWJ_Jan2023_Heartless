extends Control

export var next_scene_path: String

# Called when the node enters the scene tree for the first time.
func _ready():
	$NextSceneTimer.connect("timeout", self, "on_next_scene_timer_timeout")
	
func on_next_scene_timer_timeout() -> void:
	get_tree().root.get_child(0).change_scene(next_scene_path)
