extends Node

signal active_character_changed

const ntsc_filter_scene = preload("res://PostProcessing/NTSCFilter.tscn")
const text_box_scene = preload("res://Scenes/Engine/TextBox.tscn")
const screen_fade_scene = preload("res://Scenes/Engine/ScreenFade.tscn")

var active_character
var canvas_layer
var ui_layer
var view_effects_layer
var screen_effects_layer
var ntsc_filter
var text_box
var screen_fade

enum {
	LAYER_VIEW_EFFECTS,
	LAYER_UI,
	LAYER_SCREEN_EFFECTS,
	LAYER_CANVAS
}

func switch_active_character(character):
	emit_signal("active_character_changed", active_character, character)
	active_character = character

func show_text(key, placeholders = [], do_close_on_finish = true):
	if is_instance_valid(text_box):
		text_box.show_text(key, placeholders, do_close_on_finish)
	else:
		text_box = text_box_scene.instance()
		ui_layer.add_child(text_box)
		text_box.show_text(key, placeholders, do_close_on_finish)

func hide_text(hide_while_paused = false):
	if is_instance_valid(text_box):
		if hide_while_paused:
			text_box.pause_mode = Node.PAUSE_MODE_PROCESS
		text_box.hide_text()

func connect_text(signal_name, target, method, binds=[], flags=0):
	if is_instance_valid(text_box) && !text_box.is_connected(signal_name, target, method):
		var _return = text_box.connect(signal_name, target, method, binds, flags)
		return true
	else:
		return false

func disconnect_text(signal_name, target, method):
	if is_instance_valid(text_box) && text_box.is_connected(signal_name, target, method):
		text_box.disconnect(signal_name, target, method)
		return true
	else:
		return false

func fade_in(time = 1.0, delay = 0.0, color = Color.black, start = 0.0, end = 1.0, delete_after_fade = true, target_layer = LAYER_VIEW_EFFECTS):
	if is_instance_valid(screen_fade):
		start = screen_fade.fade_position
		screen_fade.queue_free()
	screen_fade = screen_fade_scene.instance()
	call_deferred("add_child_to_layer", target_layer, screen_fade)
	screen_fade.fade_in(time, delay, color, start, end, delete_after_fade)
	return screen_fade

func fade_out(time = 1.0, delay = 0.0, color = Color.black, start = 1.0, end = 0.0, target_layer = LAYER_VIEW_EFFECTS):
	if is_instance_valid(screen_fade):
		start = screen_fade.fade_position
		screen_fade.queue_free()
	screen_fade = screen_fade_scene.instance()
	call_deferred("add_child_to_layer", target_layer, screen_fade)
	screen_fade.fade_out(time, delay, color, start, end)
	return screen_fade

func add_child_to_layer(target_layer, node, legible_unique_name=false):
	match target_layer:
		LAYER_VIEW_EFFECTS:
			view_effects_layer.add_child(node, legible_unique_name)
		LAYER_UI:
			ui_layer.add_child(node, legible_unique_name)
		LAYER_SCREEN_EFFECTS:
			screen_effects_layer.add_child(node, legible_unique_name)
		LAYER_CANVAS:
			canvas_layer.add_child(node, legible_unique_name)

func _ready():
	#Setting up the Canvas Layer
	canvas_layer = CanvasLayer.new()
	canvas_layer.name = "EngineCanvas"
	
	#Setting up View Effects Layer
	view_effects_layer = Control.new()
	view_effects_layer.name = "ViewEffects"
	canvas_layer.call_deferred("add_child", view_effects_layer)
	
	#Setting up the UI Layer
	ui_layer = Control.new()
	ui_layer.name = "EngineUI"
	canvas_layer.call_deferred("add_child", ui_layer)
	
	#Setting up Screen Effects Layer
	screen_effects_layer = Control.new()
	screen_effects_layer.name = "ScreenEffects"
	canvas_layer.call_deferred("add_child", screen_effects_layer)
	
	#Setting up the NTSC Filter
	ntsc_filter = ntsc_filter_scene.instance()
	canvas_layer.call_deferred("add_child", ntsc_filter)
	
	get_node("/root").call_deferred("add_child", canvas_layer)

func reload_scene():
	hide_text(true)
	get_tree().set_pause(true)
	yield(EngineData.fade_out(1.0, 0.5, Color.black, 1.0, 0.0, LAYER_SCREEN_EFFECTS), "faded_out")
	var _return = get_tree().reload_current_scene()
	get_tree().set_pause(false)
