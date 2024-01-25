class_name PlayerEntity
extends KinematicBody

onready var player_model = get_node("Model") as AnimationController

func _ready():
	player_model.animation_player.set_blend_time("Idle", "Walk", 0.25)
	player_model.animation_player.set_blend_time("Idle", "Run", 0.25)
	player_model.animation_player.set_blend_time("Walk", "Idle", 0.25)
	player_model.animation_player.set_blend_time("Run", "Idle", 0.25)
	player_model.animation_player.set_blend_time("Walk", "Run", 0.25)
	player_model.animation_player.set_blend_time("Run", "Walk", 0.25)
	get_tree().root.get_camera().set_auto(self, Vector3(0.0, 0.0, 2.556), Vector3(0.0, 2.272, 0.0), deg2rad(-20))

func update_animation_state(state = "Idle", speed = 1.0):
	player_model.play_animation(state, speed)
