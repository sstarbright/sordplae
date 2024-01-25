class_name AnimationController
extends Spatial

onready var animation_player = get_node("AnimationPlayer")
export var start_animation = ""
export var start_blend_amount = -1.0
export var start_speed = 1.0
export var start_from_end = false

func _ready():
	play_animation(start_animation)

func play_animation(animation_name = "", speed = 1.0):
	animation_player.play(animation_name, -1.0, speed)

func change_position(position = 0.0):
	animation_player.current_animation_position = position
