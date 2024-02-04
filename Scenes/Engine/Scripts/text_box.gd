class_name TextBox
extends Control

enum TransitionType {
	LINEAR,
	SINE,
	QUINTIC,
	QUARTIC,
	QUADRATIC,
	EXPONENTIAL,
	ELASTIC,
	CUBIC,
	CIRCULAR,
	BOUNCE,
	BACK,
}

const offscreen_pos = 400.0
var dialogue_strings = []
var displayed_string = 0
var text_size_limit
const text_base_position = 607.0
export var show_time = 1.0
export var visible_time = 1.0
export var scroll_time = 0.5
export(TransitionType) var show_type
var show_tween
var visible_tween
var scroll_tween
var visible_finished = false
var scroll_finished = true
var is_more_text = false
onready var label = get_node("Text")
onready var continue_icon = get_node("ContinueIcon")

signal text_finished

func _ready():
	rect_position.y = offscreen_pos

func show_text(key, placeholders = []):
	visible = true
	displayed_string = 0
	var display_text = tr(key)
	if placeholders.size() > 0:
		display_text = display_text % placeholders
	dialogue_strings = display_text.split("\n", true)
	label.text = dialogue_strings[displayed_string]
	var new_line_string = displayed_string + 1
	while new_line_string < dialogue_strings.size() && dialogue_strings[new_line_string].length() <= 0:
		label.text += "\n"
		new_line_string += 1
	displayed_string = new_line_string
	continue_icon.set_visible(false)
	is_more_text = false
	visible_finished = false
	scroll_finished = true
	
	yield(get_tree(), "idle_frame")
	
	label.visible_characters = 0
	if visible_tween is SceneTreeTween && visible_tween.is_valid():
		visible_tween.kill()
	visible_tween = get_tree().create_tween()
	visible_tween.tween_property(label, "visible_characters", label.get_total_character_count(), visible_time/label.get_total_character_count())
	visible_tween.tween_callback(self, "now_visible")
	label.get_v_scroll().value = 0.0
	tween(0.0)

func now_visible():
	visible_finished = true
	if scroll_finished:
		continue_icon.set_visible(true)
		if displayed_string < dialogue_strings.size():
			is_more_text = true
		else:
			print("NO MORE TEXT")

func now_scrolled():
	scroll_finished = true
	if visible_finished:
		continue_icon.set_visible(true)
		if displayed_string < dialogue_strings.size():
			is_more_text = true
		else:
			print("NO MORE TEXT")

func hide_text():
	if scroll_tween is SceneTreeTween && scroll_tween.is_valid():
		scroll_tween.kill()
	continue_icon.set_visible(false)
	tween(offscreen_pos).tween_callback(self, "set_visible", [false])

func tween(target):
	var modified_show_time = show_time
	if show_tween is SceneTreeTween && show_tween.is_valid():
		modified_show_time = show_tween.get_total_elapsed_time()
		show_tween.kill()
	show_tween = get_tree().create_tween()
	show_tween.tween_property(self, "rect_position:y", target, modified_show_time).set_trans(show_type)
	return show_tween

func continue_text():
	if scroll_finished && visible_finished:
		if is_more_text:
			continue_icon.set_visible(false)
			is_more_text = false
			scroll_finished = false
			visible_finished = false
			label.text += "\n" + dialogue_strings[displayed_string]
			
			var new_line_string = displayed_string + 1
			while new_line_string < dialogue_strings.size() && dialogue_strings[new_line_string].length() <= 0:
				label.text += "\n"
				new_line_string += 1
			displayed_string = new_line_string
			
			yield(get_tree(), "idle_frame")
			
			visible_tween = get_tree().create_tween()
			visible_tween.tween_property(label, "visible_characters", label.get_total_character_count(), visible_time/label.get_total_character_count())
			visible_tween.tween_callback(self, "now_visible")
			scroll_tween = get_tree().create_tween()
			scroll_tween.tween_property(label.get_v_scroll(), "ratio", 1.0, scroll_time)
			scroll_tween.tween_callback(self, "now_scrolled")
		else:
			emit_signal("text_finished")
			hide_text()
	else:
		if scroll_tween is SceneTreeTween && scroll_tween.is_valid():
			scroll_tween.custom_step(scroll_time-scroll_tween.get_total_elapsed_time())
		if visible_tween is SceneTreeTween && visible_tween.is_valid():
			visible_tween.custom_step(visible_time-visible_tween.get_total_elapsed_time())
