class_name SceneManager
extends Node

var next_scene_name

func _ready():
	$TransitionScreen.connect("fade_to_black_finished", self, "on_fade_to_black_finished")
	$TransitionScreen.fade_in()
	
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen;
		
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene();

func change_scene(scene_name):	
	# Start the transition
	$TransitionScreen.fade_transition()
	next_scene_name = scene_name
	
func on_fade_to_black_finished() -> void:
	# I expect scene_name to be a path like res://ComicCutscene/comic_cutscene.tscn
	var next_level = load(next_scene_name).instance()
	print("Changing to scene: ", next_scene_name)
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(next_level)

