extends Control

var buttons = []
var current_button = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in $CenterContainer/VBoxContainer.get_children():
		if child is Button:
			buttons.append(child)
	$CenterContainer/VBoxContainer/Button.grab_focus()
	FadeTransition.fade_in()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass	
#	if Input.is_action_just_pressed("button_down"):
#		if current_button < (buttons.size() - 1):
#			current_button += 1
#		else:
#			current_button = 0
#		buttons[current_button].grab_focus()

func _on_button_pressed():
	FadeTransition.fade_to_next("res://scenes/character_select.tscn")


func _on_button_2_pressed():
	FadeTransition.fade_to_next("res://scenes/matching/matching.tscn")


func _on_button_3_pressed():
	FadeTransition.fade_to_next("res://scenes/seesaw/seesaw.tscn")
