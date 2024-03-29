extends MeshInstance2D

onready var animation_tween = get_node("Tween")

export var animation_time = 1.0

func set_visible(new_visible):
	if new_visible:
		start_tween()
	else:
		stop_tween()
	.set_visible(new_visible)

func start_tween():
	animation_tween.interpolate_property(self, "scale", Vector2.ONE, Vector2.ONE/2.0, animation_time, Tween.TRANS_SINE, 2)
	animation_tween.interpolate_property(self, "scale", Vector2.ONE/2.0, Vector2.ONE, animation_time, Tween.TRANS_SINE, 2, animation_time)
	animation_tween.start()

func stop_tween():
	animation_tween.stop_all()
