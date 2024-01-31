extends InputBool

export var amount = 1

func _ready():
	connect("on_down", self, "apply")

func apply():
	get_parent().entity_data.apply_health(amount)
