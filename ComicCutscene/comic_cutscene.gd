extends Control

export var next_scene_path: String

onready var next_button = get_node("MarginContainer/HBoxContainer/VBoxContainer/NextButton")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_NextButton_pressed():
	print("comic button pressed")
	get_tree().change_scene(next_scene_path)


func _on_NextButton1_pressed():
	print("comic button pressed")
	get_tree().change_scene(next_scene_path)


func _on_NextButton1_button_down():
	print("comic button pressed")
	get_tree().change_scene(next_scene_path)
