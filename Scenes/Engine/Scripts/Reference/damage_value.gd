class_name DamageValue
extends Reference

enum Types {
	NONE,
	SLAM,
	STAB,
	BURN,
	SHOCK
}

var amount
var type

func _init(p_amount = 1, p_type = Types.NONE):
	amount = p_amount
	type = p_type
