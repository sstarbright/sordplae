extends ColorRect

onready var tween = get_node("Tween") as Tween
onready var fade_material = material as ShaderMaterial
var fade_position = 0.0

signal faded_out
signal faded_in

func _ready():
	pass

func fade_in(time, delay, fade_color, start, end, delete_after_fade):
	call_deferred("do_fade_in", time, delay, fade_color, start, end, delete_after_fade)

func fade_out(time, delay, fade_color, start, end):
	call_deferred("do_fade_out", time, delay, fade_color, start, end)

func do_fade_in(time, delay, fade_color, start, end, delete_after_fade):
	fade_material.set_shader_param("fade_color", fade_color)
	fade_position = start
	if delay > 0.0:
		yield(get_tree().create_timer(delay), "timeout")
	if delete_after_fade:
		tween.interpolate_callback(self, time, "queue_free")
	fade(time, start, end, "faded_in")

func do_fade_out(time, delay, fade_color, start, end):
	fade_material.set_shader_param("fade_color", fade_color)
	fade_position = start
	if delay > 0.0:
		yield(get_tree().create_timer(delay), "timeout")
	fade(time, start, end, "faded_out")

func fade(time, start, end, target_signal = "faded_in"):
	start = clamp(start, 0.0, 1.0)
	end = clamp(end, 0.0, 1.0)
	tween.remove_all()
	tween.interpolate_property(self, "fade_position", start, end, time, Tween.TRANS_LINEAR)
	tween.interpolate_callback(self, time, "emit_signal", target_signal)
	tween.start()

func call_faded_out():
	emit_signal("faded_out")

func call_faded_in():
	emit_signal("faded_in")

func _process(_delta):
	fade_material.set_shader_param("fade_amount", fade_position)

func stop():
	tween.stop_all()
