extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().set_input_as_handled()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if event.is_action_pressed("button_b"):
		print("skipped")
		FadeTransition.fade_to_next("res://copyright.tscn")
