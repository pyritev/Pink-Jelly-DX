extends Node2D

@onready var jelly_music = [
	preload("res://assets/music/jelly_music0.ogg"),
	preload("res://assets/music/jelly_music1.ogg")
]
@onready var panda_music = [
	preload("res://assets/music/panda_music0.ogg"),
	preload("res://assets/music/panda_music1.ogg")
]

@onready var panda_backgrounds = preload("res://assets/images/adventure/level/pandaadventure.png")
@onready var pause_menu = preload("res://scenes/pause.tscn")

var cleared = false
@onready var music = $Music
@onready var player = $Player
@export var background = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if (Globals.stars >= Globals.stars_to_win) and !Globals.play_forever:
		get_tree().change_scene_to_file("res://scenes/congrats.tscn")
	for child in get_children():
		if child is Enemy:
			child.speed = child.speed * Globals.enemy_speed
			if Globals.level_style == 1:
				child.variant = 0
			else:
				child.variant = 1
			child.initialize()
	if Globals.level_style == 0:
		# pink jelly alternates the music between every world
		if background == 0 or background == 2:
			music.stream = jelly_music[0]
	else:
		# panda adventure alternates the music between every level
		if Globals.current_level % 2 == 0:
			music.stream = panda_music[0]
		else:
			music.stream = panda_music[1]
		$Backgrounds.texture = panda_backgrounds
	FadeTransition.fade_in()
	music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_success_plane_body_entered(body):
	if body.name == "Player" and !cleared:
		$Complete.play()
		$Timer.start()
		get_tree().paused = true
		FadeTransition.fade_out()
		cleared = true
		music.stop()


func _on_fall_plane_body_entered(body):
	if body.name == "Player":
		body.death("fall")

func _unhandled_input(event):
	if event.is_action_pressed("button_start"):
		var pause = pause_menu.instantiate()
		add_child(pause)


func _on_timer_timeout():
	get_tree().paused = false
	Globals.next_level()
	pass # Replace with function body.
