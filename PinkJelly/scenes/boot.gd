extends Node2D

var redirect = false

# Called when the node enters the scene tree for the first time.
func _ready():
	FadeTransition.show_fade()
	$CenterContainer/Label.set_text("%s\n%s\nVER %0.1f" % [Globals.BUILD_DATE, Globals.PROJECT_NAME, Globals.VERSION_NUMBER])
#	if !(Input.is_action_pressed("button_a")):
#		get_viewport().set_input_as_handled()
#		get_tree().change_scene_to_file("res://copyright.tscn")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if redirect:
		if (Input.is_action_pressed("button_a") and Input.is_action_pressed("button_start")):
			FadeTransition.hide_fade()
			get_viewport().set_input_as_handled()
			redirect = false
		else:
			get_tree().change_scene_to_file("res://copyright.tscn")
		
	if Input.is_action_pressed("button_b"):
		get_tree().change_scene_to_file("res://copyright.tscn")


func _on_timer_timeout():
	redirect = true
