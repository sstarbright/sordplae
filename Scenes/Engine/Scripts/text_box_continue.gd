extends InputBool


func _ready():
	var _return = connect("on_down", self, "continue_text")

func continue_text():
	get_parent().continue_text()
