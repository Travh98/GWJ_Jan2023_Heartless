class_name Crosshair
extends Node2D

onready var crosshair_sprite = get_node("Sprite")

# our color palette
# Color(220, 237, 235)
# Color(86, 104, 157)
# Color(144, 173, 187)
# Color(38, 35, 56)

func _ready():
	# Changes only the arrow shape of the cursor.
	# This is similar to changing it in the project settings.
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_custom_mouse_cursor(crosshair_sprite)

func _process(delta):
	self.global_position = get_global_mouse_position() 

func setChargedAttackReady(ready : bool) -> void:
	if ready:
		crosshair_sprite.self_modulate = Color8(38, 35, 56) 	# Color8 supports the 0 - 255 rgb scale
	else:
		crosshair_sprite.self_modulate = Color(1, 1, 1)			# Clear the modulation of the sprite color
