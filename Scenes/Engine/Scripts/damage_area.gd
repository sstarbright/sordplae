extends Area

export var amount = 1
export(DamageValue.Types) var type

func _physics_process(_delta):
	for body in get_overlapping_bodies():
		body.deal_damage(DamageValue.new(amount, type))
