class_name Controllable
extends NodeInput

var input_manager

func _ready():
	var siblings = get_parent().get_children()
	for sibling in siblings:
		if sibling is InputManager:
			input_manager = sibling
