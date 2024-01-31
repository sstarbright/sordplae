class_name EntityData
extends Resource

export(int) var max_health = 12
export(int) var health = 12

signal health_changed

func _init(p_max_health = 12, p_health = 12):
	max_health = p_max_health
	health = p_health

func apply_health(apply_amount = 1):
	health = clamp(health+apply_amount, 0, max_health)
	emit_signal("health_changed", max_health, health)
