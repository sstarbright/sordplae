extends Label

func _ready():
	var _return = EngineData.connect("active_character_changed", self, "switch_active_character")
	if is_instance_valid(EngineData.active_character) && "entity_data" in EngineData.active_character:
		EngineData.active_character.entity_data.connect("health_changed", self, "health_changed")

func switch_active_character(previous_character, new_character):
	if is_instance_valid(previous_character) && "entity_data" in previous_character:
		previous_character.entity_data.disconnect("health_changed", self, "health_changed")
	if new_character && "entity_data" in new_character:
		new_character.entity_data.connect("health_changed", self, "health_changed")
		health_changed(new_character.entity_data.max_health, new_character.entity_data.health)

func queue_free():
	if is_instance_valid(EngineData.active_character) && "entity_data" in EngineData.active_character:
		EngineData.active_character.entity_data.disconnect("health_changed", self, "health_changed")
	.queue_free()

func health_changed(max_health, health):
	text = ""
	var half_health = health/2
	for _x in range(half_health):
		text += "0"
	for _x in range(health-(half_health*2)):
		text += "o"
	for _x in range((max_health-health)/2):
		text += "X"
