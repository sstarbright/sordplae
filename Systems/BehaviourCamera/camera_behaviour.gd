class_name CameraBehaviour
extends Reference

var parent

func start(parent_camera):
	parent = parent_camera as Camera
	return self

func update_behaviour(_delta):
	pass
