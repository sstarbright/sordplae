extends Spatial

var warps = []
onready var camera = get_tree().root.get_camera() as BehaviourCamera

func _ready():
	for child in get_children():
		if child is Spatial:
			warps.append(child)

func call_warp(warp_id):
	if warp_id < warps.size():
		EngineData.active_character.global_translation = warps[warp_id].global_translation
		camera.auto_behaviour.last_target_position = EngineData.active_character.global_translation
		camera.auto_behaviour.target_position = EngineData.active_character.global_translation
		camera.auto_behaviour.target_y = EngineData.active_character.global_translation.y
		camera.auto_behaviour.current_y = camera.auto_behaviour.target_y
		camera.auto_behaviour.update_behaviour(0.0)
