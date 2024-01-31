class_name AutoCameraBehaviour
extends CameraBehaviour

var target
var targ_offset
var cam_offset
var rotation
var target_rotation
var rotation_offset
var target_delta
const right_angle = PI/2
var turn_rotation_speed
var last_target_position
var track_y = true
var target_position
var target_y
var current_y
var target_current_difference
const y_lerp_speed = 3.0
const non_track_bounds = Vector2(-0.3, 0.75)

func start_behaviour(camera_target, target_offset, camera_offset, camera_rotation_offset, start_rotation, turn_speed = 7.5):
	target = camera_target as Spatial
	targ_offset = target_offset
	cam_offset = camera_offset
	rotation = start_rotation
	rotation_offset = camera_rotation_offset
	last_target_position = target.translation
	last_target_position.y = 0.0
	target_position = target.translation
	current_y = target_position.y
	target_y = target_position.y
	turn_rotation_speed = turn_speed

func update_behaviour(delta):
	target_delta = target.translation - last_target_position
	target_delta.y = 0.0
	
	target_position = target.translation
	target_y = target_position.y
	
	if track_y:
		current_y = move_toward(current_y, target_y, delta*y_lerp_speed)
	else:
		target_current_difference = target_y-current_y
		if target_current_difference < non_track_bounds.x:
			current_y = target_y-non_track_bounds.x
		if target_current_difference > non_track_bounds.y:
			current_y = target_y-non_track_bounds.y
	
	target_position.y = current_y
	rotation = wrapf(rotation - sin(Vector2(target_delta.x, target_delta.z).rotated(right_angle+parent.rotation.y).angle())*turn_rotation_speed*target_delta.length_squared(), 0.0, TAU)
	parent.transform = Transform.IDENTITY.translated(target_position+targ_offset.rotated(Vector3.UP, rotation)).looking_at(target_position, Vector3.UP).translated(cam_offset)
	parent.rotation.x += rotation_offset
	last_target_position = target.translation
	last_target_position.y = 0.0
