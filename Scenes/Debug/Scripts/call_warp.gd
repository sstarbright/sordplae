extends InputBool

export var warp_id = 0

func _ready():
	connect("on_down", self, "call_warp")

func call_warp():
	get_parent().call_warp(warp_id)
