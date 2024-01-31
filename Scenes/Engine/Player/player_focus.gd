extends InputBool

onready var player_camera = get_tree().root.get_camera() as BehaviourCamera
onready var player_model = get_parent().get_node("Model")

func _ready():
	var _connect = connect("on_down", self, "on_press")

func on_press():
	player_camera.auto_behaviour.rotation = player_model.rotation.y + PI
