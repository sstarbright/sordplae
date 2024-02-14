extends Spatial

export(Array, PackedScene) var ui_elements

var instanced_ui_elements = Array()

func _ready():
	for ui_element in ui_elements:
		ui_element = ui_element as PackedScene
		instanced_ui_elements.append(ui_element.instance())
		EngineData.ui_layer.call_deferred("add_child", instanced_ui_elements.back())

func _exit_tree():
	for ui_element in instanced_ui_elements:
		ui_element.queue_free()
