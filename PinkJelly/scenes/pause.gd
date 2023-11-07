extends Control

var secret = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	$Stars.update(Globals.stars)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("button_a") and Input.is_action_pressed("button_b") and Input.is_action_pressed("button_select") and Input.is_action_pressed("button_down"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		get_tree().change_scene_to_file("res://title.tscn")

func _input(event):
	if event.is_action_pressed("button_start"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		queue_free()
	
	if event.is_action_pressed("button_select"):
		
		if Globals.play_forever and Globals.stars == Globals.stars_to_win:
			get_viewport().set_input_as_handled()
			get_tree().change_scene_to_file("res://scenes/congrats.tscn")
			get_tree().paused = false
		elif Globals.play_forever and Globals.stars != Globals.stars_to_win:
			get_viewport().set_input_as_handled()
			get_tree().change_scene_to_file("res://title.tscn")
			get_tree().paused = false
	
	if event.is_pressed():
		if secret <= 7:
			match secret:
				0, 6:
					if Input.is_action_just_pressed("button_up"):
						secret += 1
					else:
						secret = 0
				1, 4:
					if Input.is_action_just_pressed("button_right"):
						secret += 1
					else:
						secret = 0
				2:
					if Input.is_action_just_pressed("button_a"):
						secret += 1
					else:
						secret = 0
				3:
					if Input.is_action_just_pressed("button_down"):
						secret += 1
					else:
						secret = 0
				5:
					if Input.is_action_just_pressed("button_b"):
						secret += 1
					else:
						secret = 0
				7:
					if Input.is_action_just_pressed("button_left"):
						secret += 1
						get_tree().paused = false
						get_tree().change_scene_to_file("res://scenes/pgt.tscn")
					else:
						secret = 0
