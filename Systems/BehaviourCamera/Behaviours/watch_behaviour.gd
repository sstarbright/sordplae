class_name WatchCameraBehaviour
extends CameraBehaviour

var target
var offset

func start_behaviour(translation, camera_target, target_offset):
	parent.translation = translation
	target = camera_target as Spatial
	offset = target_offset

func update_behaviour(_delta):
	parent.transform = parent.transform.looking_at(target.translation+offset, Vector3.UP)
