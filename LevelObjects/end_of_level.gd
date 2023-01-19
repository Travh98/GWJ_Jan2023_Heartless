extends Area2D


# Declare member variables here. Examples:
export var next_level_scene: String


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body: Node) -> void:
	if body is PlayerCharacter:
		get_tree().root.get_child(0).change_scene(next_level_scene)
