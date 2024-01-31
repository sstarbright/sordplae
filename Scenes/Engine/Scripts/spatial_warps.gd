extends Spatial

var warps = []

func _ready():
	for child in get_children():
		if child is Spatial:
			warps.append(child)

func call_warp(warp_index):
	
