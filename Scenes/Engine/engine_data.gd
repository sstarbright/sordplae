extends Node

signal active_character_changed

const ntsc_filter_scene = preload("res://Post Processing/NTSCFilter.tscn")
const text_box_scene = preload("res://Scenes/Engine/TextBox.tscn")

var active_character
var ui_layer
var ntsc_filter
var text_box

func switch_active_character(character):
	emit_signal("active_character_changed", active_character, character)
	active_character = character

func _ready():
	ui_layer = CanvasLayer.new()
	ui_layer.name = "EngineUI"
	text_box = text_box_scene.instance()
	ui_layer.call_deferred("add_child", text_box)
	ntsc_filter = ntsc_filter_scene.instance()
	ui_layer.call_deferred("add_child", ntsc_filter)
	get_node("/root").call_deferred("add_child", ui_layer)
