extends Control

@onready var options = preload("res://scenes/settings_menu.tscn")

# this script is going to be extremely embarassing oh my god

var initialized = false
var selected = false
var options_enabled = false
var current_character = 0

@onready var characters = [
	$CenterContainer/VBoxContainer/Row1Container/Row1/Jelly,
	$CenterContainer/VBoxContainer/Row1Container/Row1/Panda,
	$CenterContainer/VBoxContainer/Row1Container/Row1/Hummer,
	$CenterContainer/VBoxContainer/Row2/Rings1,
	$CenterContainer/VBoxContainer/Row2/Rings2,
	$CenterContainer/VBoxContainer/Row2/Rings3,
	$CenterContainer/VBoxContainer/Row2/Rings4,
]

func _ready():
	SignalBus.connect("options_closed", _on_Options_closed)
	FadeTransition.fade_in()

func _process(delta):
	if !initialized:
		$CenterContainer/Selector.position = Vector2(characters[0].get_global_position().x, characters[0].get_global_position().y - 32)
		initialized = true
	if !selected and !options_enabled:
		if Input.is_action_just_pressed("button_up"):
			change_character("up")
		if Input.is_action_just_pressed("button_down"):
			change_character("down")
		if Input.is_action_just_pressed("button_right"):
			change_character("right")
		if Input.is_action_just_pressed("button_left"):
			change_character("left")
		if Input.is_action_just_pressed("button_a") or Input.is_action_just_pressed("button_start"):
			select()
		if Input.is_action_just_released("button_b"):
			display_options()
	pass

func change_character(direction):
	# DO NOT BE ME DO NOT DO THIS LMAO
	var changed = false
	match direction:
		"down":
			if current_character <= 2:
				current_character += 4
				changed = true
		"up":
			if current_character > 2:
				if current_character == 5:
					current_character -= 4
				else:
					current_character -= 4
				changed = true
		"right":
			if current_character == 2:
				current_character = 0
			elif current_character != characters.size() - 1:
				current_character += 1
			else:
				current_character = 3
			changed = true
		"left":
			if current_character == 3:
				current_character = 6
			elif current_character != 0:
				current_character -= 1
			else:
				current_character = 2
			changed = true
	if changed == true:
		if current_character > (characters.size() - 1):
			current_character = characters.size() - 1
		elif current_character < 0:
			current_character = 0
		$Move.play()
		$CenterContainer/Selector.position = Vector2(characters[current_character].get_global_position().x, characters[current_character].get_global_position().y - 32)

func select():
	selected = true
	$Select.play()
	Globals.character = current_character
	if Input.is_action_pressed("button_b"):
		Globals.play_forever = true
	else:
		Globals.play_forever = false
	Globals.start_game()
	FadeTransition.fade_to_next(Globals.levels[0])

func display_options():
	$Move.play()
	options_enabled = true
	$CenterContainer.visible = false
	var new_options = options.instantiate()
	add_child(new_options)

func _on_Options_closed():
	$CenterContainer.visible = true
	options_enabled = false
	$Move.play()
