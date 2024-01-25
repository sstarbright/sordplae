class_name AutoCameraBehaviour
extends CameraBehaviour

var target
var targ_offset
var cam_offset
var rotation
var rotation_offset
var target_delta
const right_angle = PI/2
var turn_rotation_ratio
var last_target_position

func start_behaviour(camera_target, target_offset, camera_offset, camera_rotation_offset, start_rotation, rotation_ratio = 15):
	target = camera_target as Spatial
	targ_offset = target_offset
	cam_offset = camera_offset
	rotation = start_rotation
	rotation_offset = camera_rotation_offset
	last_target_position = target.translation
	turn_rotation_ratio = rotation_ratio

func update_behaviour(_delta):
	target_delta = target.translation - last_target_position
	rotation = wrapf(rotation - sin(Vector2(target_delta.x, target_delta.z).rotated(right_angle+parent.rotation.y).angle())/(turn_rotation_ratio/(target_delta.length_squared()+1.0)), 0.0, TAU)
	parent.transform = Transform.IDENTITY.translated(target.translation+targ_offset.rotated(Vector3.UP, rotation)).looking_at(target.translation, Vector3.UP).translated(cam_offset)
	parent.rotation.x += rotation_offset
	last_target_position = target.translation
