extends Controllable

const angle_offset = PI/2

onready var move_action = input_manager.inputs["Move"]
onready var player_entity = get_parent() as PlayerEntity
onready var player_camera = player_entity
var gravity = Vector3.DOWN
export var move_speed = 0.25
export var move_sensitivity = 2.0
export var run_threshold = 1.0
var move_strength = 0.0
var move_vector = Vector2.ZERO

func _physics_process(delta):
	move_vector = move_vector.move_toward(move_action.current.rotated(-get_tree().root.get_camera().transform.basis.get_euler().y), delta*move_sensitivity)
	move_strength = move_vector.length_squared()
	if move_strength > 0.0:
		if move_strength > run_threshold:
			player_entity.update_animation_state("Run", 1.0)
		else:
			player_entity.update_animation_state("Walk", (move_strength+0.25)*4.5)
		player_entity.player_model.rotation.y = angle_offset-move_vector.angle()
		player_entity.translation += Vector3(move_vector.x, 0.0, move_vector.y)*move_speed
	else:
		player_entity.update_animation_state("Idle", 1.0)
