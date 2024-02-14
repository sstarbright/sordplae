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
export var reveal_time = 80.0
export var scroll_time = 0.5
export(TransitionType) var show_type
var show_tween
var reveal_tween
var scroll_tween
var reveal_finished = false
var scroll_finished = true
var is_more_text = false
var close_on_finish = true
onready var label = get_node("Text")
onready var continue_icon = get_node("ContinueIcon")

signal text_finished

func _ready():
	rect_position.y = offscreen_pos

func show_text(key, placeholders = [], do_close_on_finish = true):
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
	reveal_finished = false
	scroll_finished = true
	close_on_finish = do_close_on_finish
	
	label.visible_characters = 0
	if reveal_tween is SceneTreeTween && reveal_tween.is_valid():
		reveal_tween.kill()
	reveal_tween = get_tree().create_tween()
	if pause_mode == PAUSE_MODE_PROCESS:
		reveal_tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	reveal_tween.tween_property(label, "visible_characters", label.text.length(), reveal_time/label.text.length())
	reveal_tween.tween_callback(self, "now_revealed")
	label.get_v_scroll().value = 0.0
	tween(0.0)

func now_revealed():
	reveal_finished = true
	if scroll_finished:
		continue_icon.set_visible(true)
		if displayed_string < dialogue_strings.size():
			is_more_text = true

func now_scrolled():
	scroll_finished = true
	if reveal_finished:
		continue_icon.set_visible(true)
		if displayed_string < dialogue_strings.size():
			is_more_text = true

func hide_text():
	scroll_finished = false
	reveal_finished = false
	if scroll_tween is SceneTreeTween && scroll_tween.is_valid():
		scroll_tween.kill()
	continue_icon.set_visible(false)
	tween(offscreen_pos).tween_callback(self, "queue_free")

func tween(target):
	var modified_show_time = show_time
	if show_tween is SceneTreeTween && show_tween.is_valid():
		modified_show_time = show_tween.get_total_elapsed_time()
		show_tween.kill()
	show_tween = get_tree().create_tween()
	if pause_mode == PAUSE_MODE_PROCESS:
		show_tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	show_tween.tween_property(self, "rect_position:y", target, modified_show_time).set_trans(show_type)
	return show_tween

func continue_text():
	if scroll_finished && reveal_finished:
		if is_more_text:
			continue_icon.set_visible(false)
			is_more_text = false
			scroll_finished = false
			reveal_finished = false
			label.text += "\n" + dialogue_strings[displayed_string]
			
			var new_line_string = displayed_string + 1
			while new_line_string < dialogue_strings.size() && dialogue_strings[new_line_string].length() <= 0:
				label.text += "\n"
				new_line_string += 1
			displayed_string = new_line_string
			
			yield(get_tree(), "idle_frame")
			
			reveal_tween = get_tree().create_tween()
			if pause_mode == PAUSE_MODE_PROCESS:
				reveal_tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
			reveal_tween.tween_property(label, "visible_characters", label.get_total_character_count(), reveal_time/label.get_total_character_count())
			reveal_tween.tween_callback(self, "now_revealed")
			scroll_tween = get_tree().create_tween()
			if pause_mode == PAUSE_MODE_PROCESS:
				scroll_tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
			scroll_tween.tween_property(label.get_v_scroll(), "ratio", 1.0, scroll_time)
			scroll_tween.tween_callback(self, "now_scrolled")
		else:
			if close_on_finish:
				hide_text()
			emit_signal("text_finished")
	else:
		if scroll_tween is SceneTreeTween && scroll_tween.is_valid():
			scroll_tween.custom_step(scroll_time-scroll_tween.get_total_elapsed_time())
		if reveal_tween is SceneTreeTween && reveal_tween.is_valid():
			reveal_tween.custom_step(reveal_time-reveal_tween.get_total_elapsed_time())
