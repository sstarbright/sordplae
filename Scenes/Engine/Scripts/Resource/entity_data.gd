class_name EntityData
extends Resource

export(int) var max_health = 12
export(int) var health = 12
export(float) var invulnerable_time = 1.0
var invulnerable = false

signal health_changed
signal health_empty

func _init(p_max_health = 12, p_health = 12, p_invulnerable_time = 1.0):
	max_health = p_max_health
	health = p_health
	invulnerable_time = p_invulnerable_time

func reset():
	health = max_health
	invulnerable = false
	emit_signal("health_changed", max_health, health)

func apply_health(apply_amount = 1):
	health = clamp(health+apply_amount, 0, max_health)
	emit_signal("health_changed", max_health, health)
	if health <= 0:
		emit_signal("health_empty")
