extends Area

export var amount = 1
export(DamageValue.Types) var type

func _ready():
	var _return = connect("body_entered", self, "body_entered")
	_return = connect("body_exited", self, "body_exited")

func _physics_process(_delta):
	for body in get_overlapping_bodies():
		body.deal_damage(DamageValue.new(amount, type))

func body_entered(_body):
	EngineData.show_text("DEBUG1", [get_parent().name], false)
	EngineData.connect_text("text_finished", self, "extra_text")

func extra_text():
	EngineData.disconnect_text("text_finished", self, "extra_text")
	EngineData.show_text("DEBUG1", [get_parent().name])

func body_exited(_body):
	EngineData.disconnect_text("text_finished", self, "extra_text")
	EngineData.hide_text()
