class_name PlayerEntity
extends KinematicBody

export(Resource) var entity_data = EntityData.new()
onready var player_model = get_node("Model") as AnimationController
onready var player_camera = get_tree().root.get_camera() as BehaviourCamera
var move_delta = Vector3.ZERO
export var max_gravity = 220.0
var gravity = 0.0
export var gravity_acceleration = 1.0
export var snap_length = 0.2
var snap = Vector3.ZERO
var floor_normal = Vector3.UP

func _ready():
	EngineData.switch_active_character(self)
	EngineData.fade_in(1.0, 0.5, Color.black, 0.0, 1.0, true, EngineData.TargetLayers.SCREEN_EFFECTS)
	get_tree().root.get_camera().set_auto(self, Vector3(0.0, 0.0, 2.556), Vector3(0.0, 2.272, 0.0), deg2rad(-20))
	var visible_tween = get_tree().create_tween()
	visible_tween.tween_interval(1.0)
	entity_data.reset()
	entity_data.connect("health_empty", self, "kill")
	player_model.animation_player.set_blend_time("Idle", "Walk", 0.25)
	player_model.animation_player.set_blend_time("Idle", "Run", 0.25)
	player_model.animation_player.set_blend_time("Walk", "Idle", 0.25)
	player_model.animation_player.set_blend_time("Run", "Idle", 0.25)
	player_model.animation_player.set_blend_time("Walk", "Run", 0.25)
	player_model.animation_player.set_blend_time("Run", "Walk", 0.25)

func update_animation_state(state = "Idle", speed = 1.0):
	player_model.play_animation(state, speed)

func _physics_process(delta):
	var _return = move_and_slide_with_snap(move_delta+(gravity*-floor_normal*delta), snap, Vector3.UP)
	if is_on_floor():
		player_camera.auto_behaviour.track_y = true
		gravity = 0.0
		floor_normal = get_floor_normal()
		snap = -floor_normal * snap_length
	else:
		player_camera.auto_behaviour.track_y = false
		gravity = move_toward(gravity, max_gravity, delta*gravity_acceleration)
		move_delta = move_delta
		floor_normal = Vector3.UP
		snap = Vector3.ZERO

func deal_damage(damage_value):
	if !entity_data.invulnerable:
		if damage_value is DamageValue:
			entity_data.apply_health(-damage_value.amount)
			set_invulnerable()
			var invulnerable_tween = get_tree().create_tween()
			invulnerable_tween.tween_interval(entity_data.invulnerable_time)
			invulnerable_tween.tween_callback(self, "set_vulnerable")

func set_invulnerable():
	entity_data.invulnerable = true

func set_vulnerable():
	entity_data.invulnerable = false

func kill():
	EngineData.reload_scene()
