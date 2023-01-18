extends Area2D
class_name AxeSwingAttack

var despawn_timer
export var move_speed = 200
var moving_attack : bool = false
var damage : int = 50

func _ready():
	self.connect("body_entered", self, "on_body_entered")
	
	despawn_timer = get_node("DespawnTimer")
	despawn_timer.connect("timeout", self, "despawn")
	
func _physics_process(delta):
	# This code sends the axe attack flying outwards from the player
	if moving_attack:
		position += Vector2(1, 0).rotated(rotation) * delta * move_speed
	
	
func on_body_entered(body : Node) -> void:
	if body is FlyingMonkey:
		# Damage the monkey, knock it back
		print("Hit monkey for", damage)
		
func despawn() -> void:
	queue_free()

func set_moving_attack(moving : bool) -> void:
	moving_attack = moving

func set_damage(dmg : int) -> void:
	damage = dmg
