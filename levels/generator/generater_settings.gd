class_name GeneratorSettings
extends Resource
"""
Resource responsable supplying the walker setting the the level generator.
"""

export var walker_min_amount := 16
export var walker_max_amount := 20
export var walker_min_steps := 24
export var walker_max_steps := 32
export var walker_min_size := 2
export var walker_max_size := 3
export(float, 0, 1) var walker_turn_chance := 0.5
export(float, 0, 1) var walker_split_chance := 0.1
export var walker_min_split_amount := 1
export var walker_max_split_amount := 2
