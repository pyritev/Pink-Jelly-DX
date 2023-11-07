extends Control

var player_skipped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	FadeTransition.fade_in()

func _input(event):
	if (event.is_action_pressed("button_a") or event.is_action_pressed("button_start")) and !player_skipped:
		$Accept.play()
		next_scene()
		player_skipped = true

func next_scene():
	FadeTransition.fade_to_next("res://scenes/character_select.tscn")
