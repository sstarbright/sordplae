extends Area

export var amount = 1
export(DamageValue.Types) var type

func _ready():
	var _return = connect("body_entered", self, "body_entered")
	_return = connect("body_exited", self, "body_exited")

#func _physics_process(_delta):
	#for body in get_overlapping_bodies():
		#body.deal_damage(DamageValue.new(amount, type))

func body_entered(_body):
	EngineData.text_box.show_text("DEBUG1", [get_parent().name])

func body_exited(_body):
	EngineData.text_box.hide_text()
