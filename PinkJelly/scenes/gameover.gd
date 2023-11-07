extends Node2D

@onready var alt_music = [preload("res://assets/sfx/panda_gameover.wav"), preload("res://assets/sfx/hummer_gameover.wav")]
@onready var character_sprites = [
	preload("res://assets/images/adventure/jelly.png"),
	preload("res://assets/images/adventure/panda.png"),
	preload("res://assets/images/adventure/hummer.png"),
	preload("res://assets/images/adventure/rings1.png"),
	preload("res://assets/images/adventure/rings2.png"),
	preload("res://assets/images/adventure/rings3.png"),
	preload("res://assets/images/adventure/rings4.png")
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	FadeTransition.fade_in()
	if Globals.character == 1:
		$Music.stream = alt_music[0]
	elif Globals.character == 2:
		$Music.stream = alt_music[1]
	$Sprite2D.texture = character_sprites[Globals.character]
	$Music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("button_select"):
		get_tree().reload_current_scene()


func _on_music_finished():
	Globals.current_level = 0
	FadeTransition.fade_to_next("res://title.tscn")
