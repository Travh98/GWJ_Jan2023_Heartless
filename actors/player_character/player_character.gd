class_name PlayerCharacter
extends KinematicBody2D

var walk_speed := 128
var temporary_speed

# Potentially modifyable stats
var attack_range = 35
var attack_cooldown_secs = 0.5
var dash_speed_modifier = 5 		# multiply speed by this
var dash_cooldown_secs = 1
var charge_attack_time_secs = 1
var attack_damage = 50
var attack_charged_modifier = 2


var attack_ready : bool = true
var dash_ready : bool = true
var outline_character : bool = false
var velocity := Vector2.ZERO
var outline_images_store : Dictionary

onready var animated_sprite: AnimatedSprite = $Sprite
onready var animated_outlines: AnimatedSprite = $SpriteOutline
onready var axe_attack_scene = load("res://actors/axe_swing_attack.tscn")

onready var afterimage_emitter : AfterimageEmitter = $AfterimageEmitter

onready var dash_timer : Timer = get_node("DashTimer")
onready var attack_cooldown_timer : Timer = get_node("AttackCooldownTimer")
onready var dash_cooldown_timer : Timer = get_node("DashCooldownTimer")
onready var charge_attack_timer : Timer = get_node("ChargeAttackTimer")

onready var crosshair : Crosshair = get_node("Crosshair")

onready var player_stats : PlayerStats = get_node("Stats")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	dash_timer.connect("timeout", self, "dash_finished")
	attack_cooldown_timer.connect("timeout", self, "attack_cooled_down")
	attack_cooldown_timer.wait_time = attack_cooldown_secs	
	dash_cooldown_timer.connect("timeout", self, "dash_cooled_down")
	dash_cooldown_timer.wait_time = dash_cooldown_secs
	
	charge_attack_timer.connect("timeout", self, "charged_attack_timeout")
	charge_attack_timer.wait_time = charge_attack_time_secs
	
	temporary_speed = walk_speed
	
	player_stats.connect("stat_changed", self, "on_stat_changed")
	generate_character_pose_outlines()
	animated_outlines.visible = false

func _physics_process(delta: float) -> void:
	var input_direction := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()

	move_and_slide(temporary_speed * input_direction)	

	if input_direction.x != 0.0 or input_direction.y != 0.0:
		if outline_character:
			animated_sprite.visible = false
			animated_outlines.play()
		else:
			animated_outlines.visible = false
			animated_sprite.play()
	else:
		if outline_character:
			animated_outlines.stop()
			animated_outlines.frame = 0
		else:
			animated_sprite.stop()
			animated_sprite.frame = 0

	if Input.is_action_just_pressed("attack"):
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
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
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		dash()
	

func _process(delta: float) -> void:
	var mouse_direction := Vector2.ZERO.direction_to(get_local_mouse_position())
	handle_mouse_direction(mouse_direction)

func handle_mouse_direction(mouse_direction: Vector2) -> void:
	if mouse_direction.y < -0.9:
		_update_sprite("up")
	elif mouse_direction.y > 0.9:
		_update_sprite("down")
	elif mouse_direction.y < -0.4 and mouse_direction.x > 0.0:
		_update_sprite("up_right")
	elif mouse_direction.y < -0.4 and mouse_direction.x < 0.0:
		_update_sprite("up_left")
	elif mouse_direction.y > 0.4 and mouse_direction.x < 0.0:
		_update_sprite("down_left")
	elif mouse_direction.y > 0.4 and mouse_direction.x > 0.0:
		_update_sprite("down_right")
	elif mouse_direction.x > 0.0:
		_update_sprite("right")
	elif mouse_direction.x < 0.0:
		_update_sprite("left")

func _update_sprite(direction: String) -> void:
	if(animated_sprite.animation != direction):
		animated_sprite.animation = direction
	if(animated_outlines.animation != direction):
		animated_outlines.animation = direction

func axe_attack() -> void:
	var attack = axe_attack_scene.instance()
	get_tree().root.get_child(0).add_child(attack) # Add attack to the first child of root (the Level itself)
	attack.global_transform.origin = global_transform.origin + Vector2(0, -16) # 16 is half the height of player sprite
	attack.rotation = get_angle_to(get_global_mouse_position())
	attack.global_transform.origin += Vector2(attack_range, 0).rotated(attack.rotation)
	
	attack.set_damage(attack_damage)
	attack_ready = false
	attack_cooldown_timer.start()
	
func charged_axe_attack() -> void:
	var attack : AxeSwingAttack = axe_attack_scene.instance()
	get_tree().root.get_child(0).add_child(attack) # Add attack to the first child of root (the Level itself)
	attack.global_transform.origin = global_transform.origin + Vector2(0, -16) # 16 is half the height of player sprite
	attack.rotation = get_angle_to(get_global_mouse_position())
	attack.global_transform.origin += Vector2(attack_range, 0).rotated(attack.rotation)
	
	# Charged attack
	attack.set_damage(attack_damage * attack_charged_modifier)
	attack.set_moving_attack(true)
	attack.scale *= 1.5
	
	attack_ready = false
	crosshair.setChargedAttackReady(false)
	attack_cooldown_timer.start()
	
func dash() -> void:
	temporary_speed = walk_speed * dash_speed_modifier
	afterimage_emitter.emitting = true
	dash_timer.start()
	dash_ready = false
	dash_cooldown_timer.start()
	
func dash_finished() -> void:
	temporary_speed = walk_speed
	afterimage_emitter.emitting = false
	
func attack_cooled_down() -> void:
	attack_ready = true
	
func dash_cooled_down() -> void:
	dash_ready = true
	
func charged_attack_timeout() -> void:
	# TODO Here we should have some indicator to let the player know their charged attack is ready
	# Whether its a sound effect or a sprite on the screen 
	print("Charged attack is ready")
	crosshair.setChargedAttackReady(true)
	
# stat_changed signal comes from PlayerStats component
func on_stat_changed(stat_name, value) -> void:
	if stat_name == "health":
		# Set max health
		pass
	if stat_name == "walk_speed":
		walk_speed = value
	if stat_name == "attack_speed":
		attack_cooldown_secs = value
	if stat_name == "knockback":
		# set knockback on attacks
		pass
	if stat_name == "damage":
		attack_damage = value
		
func generate_character_pose_outlines() -> void:
	if animated_sprite:
		var characterTexture : Texture
		var animation_sections = animated_sprite.frames.get_animation_names()
		for anim_name in animation_sections:
			outline_images_store[anim_name] = []
			for ix in range(1, animated_sprite.frames.get_frame_count(anim_name)):
				print("generate_character_pose_outlines(), animation name=", anim_name, " ,index=", ix)
				characterTexture = animated_sprite.frames.get_frame(anim_name, ix)
				var imageTexture = characterTexture.get_data()
				var newImage = outline_from_image(imageTexture)
				var texture = ImageTexture.new()
				texture.create_from_image(newImage)
				outline_images_store[anim_name].append(texture)
		for anim_key in outline_images_store:
			animated_outlines.frames.add_animation(anim_key)
			for frame_idx in outline_images_store[anim_key].size():
				var curr_image = outline_images_store[anim_key][frame_idx]
				animated_outlines.frames.add_frame(anim_key, curr_image)
				print("generate_character_pose_outlines(), animated_outlines, adding frame :", anim_key, ", ",
				frame_idx)

func outline_from_image(orig_image : Image, color : Color = Color.beige) -> Image:
	if !orig_image:
		return null
	else:
		var res : Image = orig_image.duplicate()
		var width = orig_image.get_width()
		var height = orig_image.get_height()
		var pixel
		var left_pixel; var right_pixel
		orig_image.lock()
		res.lock()
		for yi in range(0, height):
			var pixelrow_data = false
			left_pixel = -1
			right_pixel = -1
			for xi in range(0, width):
				pixel = orig_image.get_pixel(xi, yi)
				if pixel.a8 != 0:
					pixelrow_data = true
					if xi > 0:
						left_pixel = xi - 1
						break
			if left_pixel < width - 1 and left_pixel >=0:
				for xii in range(width - 1, left_pixel + 1, -1):
					pixel = orig_image.get_pixel(xii, yi)
					if pixel.a8 != 0:
						right_pixel = xii
						break
			if pixelrow_data:
				if left_pixel >= 0:
					res.set_pixel(left_pixel, yi, color)
					#print("generate_character_pose_outlines(), outline pixel :", left_pixel,
					#" , ", yi) 
				if right_pixel >= 0:
					res.set_pixel(right_pixel, yi, color)
					#print("generate_character_pose_outlines(), outline pixel :", right_pixel,
					#" , ", yi)
		res.unlock()
		orig_image.unlock()
		return res
