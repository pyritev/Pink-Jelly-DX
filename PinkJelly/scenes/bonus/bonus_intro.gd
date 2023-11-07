extends Control

@export var type : int = 0
@onready var label = $VBoxContainer/Label
@onready var sprite = $VBoxContainer/CenterContainer/Control/Sprite2D
@onready var rects = [
	$ColorRect,
	$ColorRect2,
	$ColorRect3
]
@onready var music = [
	preload("res://assets/music/bigcity.ogg"),
	preload("res://assets/music/theduck.ogg"),
	preload("res://assets/music/seesaw_score.ogg"),
	preload("res://assets/music/hummunused.ogg"),
]

@onready var bonus_scenes = [
	"res://scenes/matching/matching.tscn",
	"res://scenes/theduck/duck_game.tscn",
	"res://scenes/seesaw/seesaw.tscn",
	"res://scenes/motorboat/motorboat_game.tscn"
]

var skipped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	FadeTransition.hide_fade()
	type = Globals.bonus_type
	sprite.frame = type if type != 3 else 0
	match type:
		0:
			# matching
			rects[0].visible = true
			rects[1].visible = false
			rects[2].visible = false
			label.set_text("MATCH THE CARDS!")
			$AudioStreamPlayer.stream = music[0]
		1:
			# the duck
			rects[0].visible = false
			rects[1].visible = true
			rects[2].visible = false
			var rand_num = Globals.rng.randi_range(0,100)
			if rand_num == 21:
				label.set_text("DO YOUR ESSAY!\nSTOP\nPROCRASTINATING")
			else:
				label.set_text("SHOOT THE DUCKS!")
			$AudioStreamPlayer.stream = music[1]
		2:
			# seesaw
			rects[0].visible = false
			rects[1].visible = false
			rects[2].visible = true
			label.set_text("GATHER ITEMS &\nCOLLECT THE STAR!")
			$AudioStreamPlayer.stream = music[2]
		3:
			# boat
			rects[0].visible = true
			rects[1].visible = false
			rects[2].visible = false
			label.set_text("SAVE THE HUMMERS!")
			$AudioStreamPlayer.stream = music[3]
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("button_a"):
		if !skipped:
			skip()
			$Skip.play()

func _on_timer_timeout():
	skip()


func skip():
	skipped = true
	FadeTransition.fade_to_next(bonus_scenes[Globals.bonus_type])
