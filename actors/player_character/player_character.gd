extends KinematicBody2D
class_name PlayerCharacter

const ANIMATION_DIRECTIONS := {Vector2.RIGHT: "right", Vector2.LEFT: "left", Vector2.UP: "up", Vector2.DOWN: "down"}
const SPEED := 128
var temporary_speed

# Potentially modifyable stats
var attack_range = 35
var attack_cooldown_secs = 0.5
var dash_speed_modifier = 5 		# multiply speed by this
var dash_cooldown_secs = 1
var charge_attack_time_secs = 1


var attack_ready : bool = true
var dash_ready : bool = true
var velocity := Vector2.ZERO

onready var animated_sprite: AnimatedSprite = $Sprite
onready var axe_attack_scene = load("res://actors/axe_swing_attack.tscn")

onready var dash_timer : Timer = get_node("DashTimer")
onready var attack_cooldown_timer : Timer = get_node("AttackCooldownTimer")
onready var dash_cooldown_timer : Timer = get_node("DashCooldownTimer")
onready var charge_attack_timer : Timer = get_node("ChargeAttackTimer")

func _ready():
	dash_timer.connect("timeout", self, "dash_finished")
	attack_cooldown_timer.connect("timeout", self, "attack_cooled_down")
	attack_cooldown_timer.wait_time = attack_cooldown_secs	
	dash_cooldown_timer.connect("timeout", self, "dash_cooled_down")
	dash_cooldown_timer.wait_time = dash_cooldown_secs
	
	charge_attack_timer.connect("timeout", self, "charged_attack_timeout")
	charge_attack_timer.wait_time = charge_attack_time_secs
	
	temporary_speed = SPEED

func _physics_process(delta: float) -> void:
	var input_direction := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()

	move_and_slide(temporary_speed * input_direction)
	
#	if(Input.IsActionJustPressed("melee"))
#		{
#			_throwTimer.Start();
#		}
#		if(Input.IsActionJustReleased("melee"))
#		{
#			if(_throwTimer.TimeLeft != 0)
#			{
#				// Melee attack
#			}
#			else
#			{
#				_inventory.ThrowHeldItem();
#			}
#
#		}
	

	if Input.is_action_just_pressed("attack"):
		charge_attack_timer.start() 		# Start charging attack
		
	if Input.is_action_just_released("attack"):
		if charge_attack_timer.time_left != 0:
			# Did not charge long enough, try a regular attack
			charge_attack_timer.stop()
			if attack_ready:
				axe_attack()
		else:
			# since time left is zero, we have fully charged
			charged_axe_attack()
				
	if Input.is_action_just_pressed("dash") and dash_ready:
		dash()

func _process(delta: float) -> void:
	var mouse_direction := Vector2.ZERO.direction_to(get_local_mouse_position())
	handle_mouse_direction(mouse_direction)

func handle_mouse_direction(mouse_direction: Vector2) -> void:
	if mouse_direction.x > 0.0:
		_update_sprite(Vector2.RIGHT)
	if mouse_direction.x < 0.0:
		_update_sprite(Vector2.LEFT)
	if mouse_direction.y > 0.85:
		_update_sprite(Vector2.DOWN)
	if mouse_direction.y < -0.85:
		_update_sprite(Vector2.UP)

func _update_sprite(direction: Vector2) -> void:
	animated_sprite.animation = ANIMATION_DIRECTIONS[direction]

func axe_attack() -> void:
	var attack = axe_attack_scene.instance()
	get_tree().root.get_child(0).add_child(attack) # Add attack to the first child of root (the Level itself)
	attack.global_transform.origin = global_transform.origin + Vector2(0, -16) # 16 is half the height of player sprite
	attack.rotation = get_angle_to(get_global_mouse_position())
	attack.global_transform.origin += Vector2(attack_range, 0).rotated(attack.rotation)
	
	attack_ready = false
	attack_cooldown_timer.start()
	
func charged_axe_attack() -> void:
	var attack : AxeSwingAttack = axe_attack_scene.instance()
	get_tree().root.get_child(0).add_child(attack) # Add attack to the first child of root (the Level itself)
	attack.global_transform.origin = global_transform.origin + Vector2(0, -16) # 16 is half the height of player sprite
	attack.rotation = get_angle_to(get_global_mouse_position())
	attack.global_transform.origin += Vector2(attack_range, 0).rotated(attack.rotation)
	
	# Charged attack
	attack.set_damage(100)
	attack.set_moving_attack(true)
	attack.scale *= 1.5
	
	attack_ready = false
	attack_cooldown_timer.start()
	
func dash() -> void:
	temporary_speed = SPEED * dash_speed_modifier
	dash_timer.start()
	dash_ready = false
	dash_cooldown_timer.start()
	
func dash_finished() -> void:
	temporary_speed = SPEED
	
func attack_cooled_down() -> void:
	attack_ready = true
	
func dash_cooled_down() -> void:
	dash_ready = true
	
func charged_attack_timeout() -> void:
	# TODO Here we should have some indicator to let the player know their charged attack is ready
	# Whether its a sound effect or a sprite on the screen 
	print("Charged attack is ready")
