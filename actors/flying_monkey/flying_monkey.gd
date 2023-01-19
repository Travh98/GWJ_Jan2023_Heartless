class_name FlyingMonkey
extends KinematicBody2D

var move_speed := 20
var circling_rotate_speed := 0.5
var attacking_distance := 80
var detection_radius := 50

var velocity := Vector2.ZERO
var direction := Vector2.ZERO
var target: Node2D

var delta_degrees: float = 0 		# used to get a smooth rotation around target
var swoop_target:= Vector2.ZERO

enum States {
	Chase = 0,
	Circle = 1,
	Swoop = 2
}
var my_state = States.Chase

onready var detection_area: Area2D = $DetectionArea
onready var detection_collision: CollisionShape2D = $DetectionArea/DetectionAreaCollision
onready var swoop_timer: Timer = $SwoopTimer
onready var move_to_sprite: Sprite = $MoveToSprite # Used for debugging

onready var rng = RandomNumberGenerator.new()
var clockwise_rotation : bool = false

func _ready():
	rng.randomize()
	var rand_dir_float = rng.randf_range(0.0, 1.0)
	if(rand_dir_float > 0.5):
		clockwise_rotation = true
	else:
		clockwise_rotation = false
	delta_degrees = rng.randf_range(0.0, 359.0)
	
	detection_area.connect("body_entered", self, "on_detection_area_entered")
	detection_collision.shape.set("radius", detection_radius)

func _process(delta):
	if target == null:
		return
	
	var target_distance = transform.origin.distance_to(target.transform.origin)
	
	match my_state:
		States.Chase:
			move_speed = 50
			direction = target.transform.origin - transform.origin
			if(target_distance < attacking_distance):
				state_change(States.Circle)
				
		States.Circle:
			move_speed = 80
			delta_degrees += delta
			var desired_pos = Vector2.ZERO
			if(clockwise_rotation):
				desired_pos = Vector2(sin(delta_degrees * circling_rotate_speed) * attacking_distance, cos(delta_degrees * circling_rotate_speed) * attacking_distance) + target.global_transform.origin
			else:
				desired_pos = Vector2(sin(delta_degrees * -circling_rotate_speed) * attacking_distance, cos(delta_degrees * -circling_rotate_speed) * attacking_distance) + target.global_transform.origin
			move_to_sprite.global_transform.origin = desired_pos
			direction = desired_pos - global_transform.origin;
			if(swoop_timer.is_stopped()):
				swoop_timer.start(2.0) # Start swoop timer if not already running
			
		States.Swoop:
			move_speed = 120
			
			direction = swoop_target - transform.origin
			if(swoop_target.distance_to(global_transform.origin) < 10):
				state_change(States.Circle)
			
	velocity = move_and_slide(move_speed * direction.normalized())
	
# When player enters detection area, set player as our target
func on_detection_area_entered(body: Node2D):
	# I'm removing this if statement because the Static Typing seems to break gdscript
	# For now we can assume that the detection area will only collide with Player objects using the 2D Physics Layers
#	if(body is PlayerCharacter): 
	target = body
	
func state_change(new_state):
#	print("Changing state to:", new_state)
	my_state = new_state 
	
func _on_SwoopTimer_timeout():
	swoop_target = target.global_transform.origin + Vector2(attacking_distance * sin(get_angle_to(target.global_transform.origin)), attacking_distance * cos(get_angle_to(target.global_transform.origin))) # Monkey Attack Option A
	state_change(States.Swoop)
