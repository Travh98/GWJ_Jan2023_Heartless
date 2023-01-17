class_name PlayerStats
extends Node

signal stat_changed(stat_name, value)

export var health : int setget set_health
export var walk_speed : float setget set_walk_speed
export var attack_speed : float setget set_attack_speed
export var knockback : float setget set_knockback
export var damage : int setget set_damage

func set_health(value: int) -> void:
	health = value
	emit_signal("stat_changed", "health", health)

func set_walk_speed(value: float) -> void:
	walk_speed = value
	emit_signal("stat_changed", "walk_speed", walk_speed)

func set_attack_speed(value: float) -> void:
	attack_speed = value
	emit_signal("stat_changed", "attack_speed", attack_speed)

func set_knockback(value: float) -> void:
	knockback = value
	emit_signal("stat_changed", "knockback", knockback)

func set_damage(value: int) -> void:
	damage = value
	emit_signal("stat_changed", "damage", damage)
