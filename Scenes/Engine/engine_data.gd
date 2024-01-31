extends Node

signal active_character_changed

var active_character

func switch_active_character(character):
	emit_signal("active_character_changed", active_character, character)
	active_character = character
