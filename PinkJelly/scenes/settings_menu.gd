extends Control

const MAX_VOLUME = 10
const MAX_LIVES = 9
var STAR_OPTIONS = [6, 9]

var buttons = []
var current_focus = null
var initialized = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# print(AudioServer.get_bus_index("Master"))
	initialize_options($CenterContainer/VBoxContainer)
	buttons[0].grab_focus()
	current_focus = buttons[0]
	refresh_values()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var this_focus = get_viewport().gui_get_focus_owner()
	if this_focus != current_focus or !initialized:
		current_focus = this_focus
		$Selector.position = Vector2(current_focus.get_global_position().x - 14, current_focus.get_global_position().y + 5)
		if !initialized:
			initialized = true
	pass

func _input(event):
	if event.is_action_pressed("button_left"):
		match current_focus.name:
			"MasterVolume":
				$Move.play()
				SaveData.master_volume = adjust_volume(SaveData.master_volume, MAX_VOLUME, false, true, 0)
			"MusicVolume":
				SaveData.music_volume = adjust_volume(SaveData.music_volume, MAX_VOLUME, false, true, 1)
			"Stars":
				adjust_stars()
			"Lives":
				SaveData.lives = adjust_volume(SaveData.lives, MAX_LIVES, false, false)
	elif event.is_action_pressed("button_right"):
		match current_focus.name:
			"MasterVolume":
				$Move.play()
				SaveData.master_volume = adjust_volume(SaveData.master_volume, MAX_VOLUME, true, true, 0)
			"MusicVolume":
				SaveData.music_volume = adjust_volume(SaveData.music_volume, MAX_VOLUME, true, true, 1)
			"Stars":
				adjust_stars()
			"Lives":
				SaveData.lives = adjust_volume(SaveData.lives, MAX_LIVES, true, false)
	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right") or event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
		refresh_values()

func initialize_options(node : Control):
	for item in node.get_children():
		if item is Button:
			buttons.append(item)
	# print(buttons)

func adjust_volume(vol : int, max : int, increase : bool, volume_real : bool = true, corresponding_bus : int = -1):
	match increase:
		true:
			if vol < max:
				vol += 1
		false:
			if vol > 0:
				vol -= 1
	if volume_real:
		var volume_value = linear_to_db(((float(vol))/10))
		# print(volume_value)
		AudioServer.set_bus_volume_db(corresponding_bus, volume_value)
	return vol

func refresh_values():
	$CenterContainer3/VBoxContainer/MasterLabel.set_text(str(SaveData.master_volume))
	$CenterContainer3/VBoxContainer/MusicLabel.set_text(str(SaveData.music_volume))
	$CenterContainer3/VBoxContainer/StarLabel.set_text(str(SaveData.stars))
	$CenterContainer3/VBoxContainer/LivesLabel.set_text(str(SaveData.lives))

func adjust_stars():
	match SaveData.stars:
		6:
			SaveData.stars = STAR_OPTIONS[1]
		9:
			SaveData.stars = STAR_OPTIONS[0]


func _on_save_pressed():
	# save fuckery
	SaveData.save_data()
	Globals.stars_to_win = SaveData.stars
	SignalBus.options_closed.emit()
	queue_free()
