extends Node

const PROJECT_NAME = "PINK JELLY DX"
const BUILD_DATE = "2023-09-30"
const VERSION_NUMBER = 1.1

const DEFAULT_LIVES = 9
const DEFAULT_ENEMY_SPEED = 1.0
const MULTIPLIER = 1.1
const EXTRA_BONUS = 10000

var extra_sound = preload("res://assets/sfx/extralife.wav")
var extra_player = AudioStreamPlayer.new()

var secret_sound = preload("res://assets/sfx/jellydie.wav")
var secret_player = AudioStreamPlayer.new()

@onready var touch_controls = preload("res://touchcontrol.tscn")

var levels = [
	"res://scenes/levels/level_0.tscn",
	"res://scenes/levels/level_1.tscn",
	"res://scenes/levels/level_2.tscn",
	"res://scenes/levels/level_3.tscn",
	"res://scenes/levels/level_4.tscn",
	"res://scenes/levels/level_5.tscn",
	"res://scenes/levels/level_6.tscn",
	"res://scenes/levels/level_7.tscn",
	"res://scenes/levels/level_8.tscn",
	"res://scenes/levels/level_9.tscn",
	"res://scenes/levels/level_10.tscn",
	"res://scenes/levels/level_11.tscn"
]

var rng = RandomNumberGenerator.new()

# MAIN GAME VARS
var current_level = 0
var character = 0 # 0 jelly, 1 panda, 2 hummer, 3 - 6 rings
var lives = SaveData.lives
var level_style = 0
var score = 0
var stars_to_win = SaveData.stars
var stars = 0
var play_forever = false
var added_lives = false
var points_to_extra = EXTRA_BONUS

var enemy_speed = DEFAULT_ENEMY_SPEED

# BONUS STAGE VARIABLES
var bonus_type = 0 # 0 = matching, 1 = duck, 2 = seesaw, 3 = motorboat, 4 = running
var currently_on_bonus = false
var last_bonus = -1
var bonus_won = false

var bonus_clears = [0, 0, 0, 0]
var bonus_encounters = [0, 0, 0, 0]

func _ready():
	#if(OS.get_name() == "Android" || OS.get_name() == "Windows"):
#	add_child(touch_controls.instantiate())
	# this is the only dependency that needs to be loaded from the save data. what a mess
	stars_to_win = SaveData.stars
	
	extra_player.set_stream(extra_sound)
	add_child(extra_player)
	secret_player.set_stream(secret_sound)
	add_child(secret_player)

func _process(delta):
	if Input.is_action_pressed("reset"):
		get_tree().change_scene_to_file("res://scenes/boot.tscn")
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func next_level(fade : bool = false, advance : bool = true):
	# fade determines whether a fade transition is used; advance determines whether this command goes to the next stage or simply returns the player to the game
	if current_level > 0 and ((current_level + 1) % 3) == 0 and !currently_on_bonus and !play_forever:
		# go to a bonus stage every third level
		bonus_stage()
	else:
		# increment stage
		if advance:
			current_level += 1
			if current_level > levels.size() - 1:
				# loop around if the player has reached the last level
				current_level = 0
				# swap between rings and panda adventure style
				if level_style == 1:
					level_style = 0
				else:
					level_style = 1
				# increase enemy speed by x multiplier
				enemy_speed = enemy_speed * MULTIPLIER
		if fade:
			FadeTransition.fade_to_next(levels[current_level])
		else:
			get_tree().change_scene_to_file(levels[current_level])

func start_game():
	# reset all variables
	current_level = 0
	lives = SaveData.lives
	score = 0
	stars = 0
	bonus_clears = [0, 0, 0, 0]
	bonus_encounters = [0, 0, 0, 0]
	points_to_extra = EXTRA_BONUS
	added_lives = false
	enemy_speed = DEFAULT_ENEMY_SPEED
	last_bonus = -1
	
	# set starting level style to panda adventure if player chooses panda
	if character == 1:
		level_style = 1
	else:
		level_style = 0

func bonus_stage():
	currently_on_bonus = true
	# choose a random bonus stage
	bonus_type = rng.randi_range(0,3)
	# make sure that the player doesn't get the same bonus stage twice
	
	# todo: check if all of the bonus stages have been played yet
	# if it rolls one that has more encounters than the rest, reroll
	# if all are equal, make sure it's not the last
	if (bonus_encounters.max() > 0) and (bonus_encounters.max() != bonus_encounters.min()) and (bonus_encounters[bonus_type] == bonus_encounters.max()):
		bonus_type = rng.randi_range(0,3)
		while bonus_encounters[bonus_type] == bonus_encounters.max():
			bonus_type = rng.randi_range(0,3)
	else:
		while bonus_type == last_bonus:
			bonus_type = rng.randi_range(0,3)
	bonus_encounters[bonus_type] += 1
	last_bonus = bonus_type
	get_tree().change_scene_to_file("res://scenes/bonus/bonus_intro.tscn")

func bonus_end():
	# increment to next level
	next_level(true)
	currently_on_bonus = false

func add_star():
	stars += 1

func add_score(value):
	score += value # add points
	points_to_extra -= value # decrement points remaining until player earns an extra life
	if points_to_extra <= 0:
		lives += 1
		points_to_extra = points_to_extra + EXTRA_BONUS
		extra_player.play()
		SignalBus.extra_life.emit()

func time_convert(time_in_sec : int):
	var seconds = time_in_sec%60
	var minutes = (time_in_sec/60)%60
	return "%01d:%02d" % [minutes, seconds]
