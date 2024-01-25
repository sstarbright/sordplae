class_name BehaviourCamera
extends Camera

enum Behaviours {
	STILL,
	WATCH,
	ORBIT,
	AUTO,
	LOOK,
	LERP,
	SMOOTHDAMP,
}

var still_behaviour = StillCameraBehaviour.new().start(self) as StillCameraBehaviour
var watch_behaviour = WatchCameraBehaviour.new().start(self) as WatchCameraBehaviour
var orbit_behaviour = OrbitCameraBehaviour.new().start(self) as OrbitCameraBehaviour
var auto_behaviour = AutoCameraBehaviour.new().start(self) as AutoCameraBehaviour
var look_behaviour = LookCameraBehaviour.new().start(self) as LookCameraBehaviour
var lerp_behaviour = LerpCameraBehaviour.new().start(self) as LerpCameraBehaviour
var smoothdamp_behaviour = SmoothDampCameraBehaviour.new().start(self) as SmoothDampCameraBehaviour

var current_behaviour

func _ready():
	set_still(translation, rotation)

func _physics_process(delta):
	current_behaviour.update_behaviour(delta)

func set_still(still_translation, still_rotation):
	current_behaviour = still_behaviour
	current_behaviour.start_behaviour(still_translation, still_rotation)

func set_watch(watch_translation, watch_target, target_offset = Vector3.ZERO):
	current_behaviour = watch_behaviour
	current_behaviour.start_behaviour(watch_translation, watch_target, target_offset)

func set_auto(auto_target, target_offset = Vector3.ZERO, camera_offset = Vector3.ZERO, rotation_offset = 0.0, start_rotation = 0.0):
	current_behaviour = auto_behaviour
	current_behaviour.start_behaviour(auto_target, target_offset, camera_offset, rotation_offset, start_rotation)
