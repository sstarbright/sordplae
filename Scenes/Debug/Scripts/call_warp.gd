extends InputBool

export var warp_id = 0

func _ready():
	var _return = connect("on_down", self, "call_warp")

func call_warp():
	get_parent().call_warp(warp_id)
