extends Node2D

var selection_option = 0
var screen_visible = 0
var can_move = true

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_visible = 0
	$CenterContainer.visible = true
	FadeTransition.fade_in()
	if Globals.added_lives:
		$CenterContainer/VBoxContainer/HBoxContainer/Label2.set_text("LMAOOO")
	else:
		$CenterContainer/VBoxContainer/HBoxContainer/Label2.set_text("%06d" % Globals.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match screen_visible:
		0:
			if Input.is_action_just_pressed("button_a") or Input.is_action_just_pressed("button_start"):
				$AudioStreamPlayer2.play()
				screen_visible = 1
				$CenterContainer.visible = false
				$CenterContainer2.visible = true
		1:
			if (Input.is_action_just_pressed("button_a") or Input.is_action_just_pressed("button_start")) and can_move:
				$AudioStreamPlayer3.play()
				can_move = false
				match selection_option:
					0:
						FadeTransition.fade_to_next("res://scenes/credits.tscn")
					1:
						screen_visible = 2
						$CenterContainer2.visible = false
						$CenterContainer3.visible = true
						$Timer.start()
						Globals.play_forever = true
			if (Input.is_action_just_pressed("button_left") or Input.is_action_just_pressed("button_right") or Input.is_action_just_pressed("button_select")) and can_move:
				$AudioStreamPlayer2.play()
				change_option()

func change_option():
	# this is SO hardcoded but what i was trying isn't working and i am tired LMAO
	match selection_option:
		0:
			selection_option = 1
			$CenterContainer2/Selector.position.x = 163
		1:
			selection_option = 0
			$CenterContainer2/Selector.position.x = 70


func _on_timer_timeout():
	Globals.next_level(true, false)
