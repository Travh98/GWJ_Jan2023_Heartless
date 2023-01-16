extends Node2D
"""
Node resposable for generating levels with a walker level generation algorithm
"""

export var settings : Resource setget set_settings

var rng := RandomNumberGenerator.new()

onready var terrain: TileMap = $Terrain

class Walker extends Reference:
	const DIRECTIONS := [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
	
	var steps : int
	var size : int
	var settings : GeneratorSettings
	var position : Vector2
	var direction : int
	func _init(steps : int, size: int, settings: GeneratorSettings, position: Vector2 = Vector2()) -> void:
		self.steps = steps
		self.size = size
		self.settings = settings
		self.position = position
		self.direction = randi() % 4
	
	func step() -> void:
		position += DIRECTIONS[direction]
		steps -= 1
		if randf() < settings.walker_turn_chance:
			direction += 1 if randf() < 0.5 else -1
			direction %= 4

func _ready() -> void:
	rng.randomize()
	generate()

func generate() -> void:
	if not settings:
		push_warning("The level generator needs as walker settings resource to function.")
		return
	
	var walker_amount := rng.randi_range(settings.walker_min_amount, settings.walker_max_amount)
	
	var walkers := []
	
	for i in walker_amount:
		var walker_steps := rng.randi_range(settings.walker_min_steps, settings.walker_max_steps)
		var walker_size := rng.randi_range(settings.walker_min_size, settings.walker_max_size)
		walkers.append(
			Walker.new(walker_steps, walker_size, settings)
		)
	
	while walkers.size() > 0:
		for walker in walkers:
			walker.step()
			for x in walker.size:
				for y in walker.size:
					terrain.set_cellv(walker.position + Vector2(x, y), 0)
			terrain.update_bitmask_area(walker.position)
			if walker.steps <= 0.0:
				if randf() < settings.walker_split_chance:
					var walker_split_amount := rng.randi_range(settings.walker_min_split_amount, settings.walker_max_split_amount)
					for i in walker_split_amount:
						var walker_steps := rng.randi_range(settings.walker_min_steps, settings.walker_max_steps)
						var walker_size := rng.randi_range(settings.walker_min_size, settings.walker_max_size)
						walkers.append(
							Walker.new(walker_steps, walker_size, settings, walker.position)
						)
				walkers.erase(walker)
				

func set_settings(value: GeneratorSettings) -> void:
	settings = value
