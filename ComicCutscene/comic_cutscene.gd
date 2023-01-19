extends Control

export var next_scene_path: String

onready var next_button = get_node("MarginContainer/HBoxContainer/VBoxContainer/NextButton")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_NextButton_pressed():
	print("comic button pressed")
	get_tree().root.get_child(0).change_scene(next_scene_path)
