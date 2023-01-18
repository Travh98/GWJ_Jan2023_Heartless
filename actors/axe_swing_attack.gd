extends Area2D

var despawn_timer
#export var move_speed = 200

func _ready():
	self.connect("body_entered", self, "on_body_entered")
	
	despawn_timer = get_node("DespawnTimer")
	despawn_timer.connect("timeout", self, "despawn")
	
#func _physics_process(delta):
	# This code sends the axe attack flying outwards from the player
	#position += Vector2(1, 0).rotated(rotation) * delta * move_speed
	
	
func on_body_entered(body : Node) -> void:
	if body is FlyingMonkey:
		# Damage the monkey, knock it back
		print("Hit monkey")
		
func despawn() -> void:
	queue_free()

