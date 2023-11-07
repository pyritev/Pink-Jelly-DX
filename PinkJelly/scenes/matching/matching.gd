extends Node2D

const TIMER_DEFAULT = 60

var buttons = []
var characters_list = ["jelly", "hummer", "zdog", "duck", "lilshit", "panda"]
var characters = []
var real_buttons = [[null,null,null,null], [null,null,null,null], [null,null,null,null]]
var rng = RandomNumberGenerator.new()
var skip_progress = 0

var cards_active = []
var matched = 0
var run_check = true
var completed = false
var hurry = false
var game_end = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# difficulty increase for consecutive clears
	if Globals.bonus_clears[0] > 0:
		$Timer2.wait_time = TIMER_DEFAULT / ((1 + ((float(Globals.bonus_clears[0]))/3)))
		$Timer2.start()
	FadeTransition.hide_fade()
	rng.randomize()
	for n in 2:
		# duplicate the character list so there's two of each
		characters.append_array(characters_list)
	for item in $Control/VBoxContainer.get_children():
		# add cards to array
		var current_row = 0
		var current_col = 0
		if item is HBoxContainer:
			var card_row = []
			current_col = 0
			for card in item.get_children():
				if card is Card:
					card_row.append(card)
					current_col += 1
			buttons.append(card_row)
			current_row += 1
	
	var random_row = 0
	var random_col = 0
	for char in characters:
		# put random characters in random cards
		random_row = rng.randi_range(0,2)
		random_col = rng.randi_range(0,3)
		# check if a spot on the grid has already been populated and keep testing new cells
		while real_buttons[random_row][random_col] != null:
#			print("FUCK! someone is already there. try another position: " + str(random_row) + ", " + str(random_col))
			random_row = rng.randi_range(0,2)
			random_col = rng.randi_range(0,3)
		real_buttons[random_row][random_col] = characters_list.find(char)

	for n in 3:
		for m in 4:
			buttons[n-1][m-1].character = real_buttons[n-1][m-1]
			buttons[n-1][m-1].initialize_card()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Timer2/Label.set_text(Globals.time_convert($Timer2.time_left))

	
	if $Timer2.time_left <= 21 and !hurry and !completed:
		hurry = true
		$Hurry.play()
		$Music.stop()
		
	if cards_active.size() == 2:
		if cards_active[0].character == cards_active[1].character:
			$Match.play()
			for card in cards_active:
				card.matched = true
			cards_active.clear()
			matched += 1
			if matched == 6:
				completed = true
				game_end = true
				Globals.bonus_won = true
				$Timer.start()
				get_tree().paused = true
				Globals.add_star()
				Globals.bonus_clears[0] += 1
				$Complete.play()
				$Timer2.stop()
		else:
			if run_check:
				$NoMatch.play()
				$ShowTimer.start()
				run_check = false
	pass

func _input(event):
	if event.is_action_pressed("button_b"):
		if skip_progress < 15 and !completed and !game_end:
			skip_progress += 1
			if skip_progress == 15:
				$Timer2.set_wait_time(0.1)
				$Timer2.start()

func _on_show_timer_timeout():
	for thing in cards_active:
		thing.deactivate()
	cards_active.clear()
	run_check = true


func _on_timer_timeout():
	get_tree().paused = false
	FadeTransition.fade_to_next("res://scenes/bonus/bonus_results.tscn")


func _on_timer_2_timeout():
	if !completed:
		game_end = true
		$Fail.play()
		Globals.bonus_won = false
		get_tree().paused = true
		$Timer.start()
