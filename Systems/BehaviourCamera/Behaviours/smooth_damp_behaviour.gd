class_name SmoothDampCameraBehaviour
extends CameraBehaviour

func start_behaviour(translation, rotation):
	parent.translation = translation
	parent.rotation = rotation
