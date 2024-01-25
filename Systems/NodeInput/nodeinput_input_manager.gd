class_name InputManager
extends NodeInput

var inputs = Dictionary()
export var controller = 0

func _ready():
	var children = get_children()
	for child in children:
		if child is InputValue:
			inputs[child.name] = child
