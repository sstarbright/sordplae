extends InputBool

onready var player_entity = get_parent() as PlayerEntity
export var jump_strength = -140
const coyote_time = 0.35
var coyote_time_left = coyote_time

func _ready():
	var _connect = connect("on_down", self, "on_press")

func _physics_process(delta):
	if player_entity.is_on_floor():
		coyote_time_left = coyote_time
	else:
		coyote_time_left = move_toward(coyote_time_left, 0.0, delta)

func on_press():
	if coyote_time_left > 0.0:
		player_entity.snap = Vector3.ZERO
		player_entity.gravity = jump_strength
		coyote_time_left = 0.0
		player_entity.update_animation_state("Idle", 1.0)
