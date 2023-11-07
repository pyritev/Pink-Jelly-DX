extends Control

var player_skipped = false
var frozen = false
var b_press = 0

var random_messages = [
	"PLAY SOME MORE!",
	"INFINITE FUN!",
	"EAT UP BITCHES",
	"SUPER NEW GAME THING 7 PEOPLE",
	"PRESENTS TO START",
	"PIRATEGAMETHING PRESENTS",
	"PINK JELLY SAYS TRANS RIGHTS",
	"HUMMERS DON'T USE DRUGS",
	"YO IT DOESNT GO LOW ENOUGH",
	"WHERE IS DOWNLOAD LINK?",
	"THE GAME"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.set_text(random_messages.pick_random())
	FadeTransition.hide_fade()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if (event.is_action_pressed("button_a") or event.is_action_pressed("button_start")) and !player_skipped:
		if frozen:
			$AudioStreamPlayer.play()
			$Timer.start()
			frozen = false
		else:
			$Accept.play()
			$Timer.stop()
			next_scene()
			player_skipped = true
	if event.is_action_pressed("button_b"):
		b_press += 1
		if b_press == 5:
			frozen = true
			$AudioStreamPlayer.stop()
			$Timer.stop()
		elif b_press == 6 and frozen:
			Globals.secret_player.play()
			get_tree().change_scene_to_file("res://scenes/snake.tscn")

func next_scene():
	FadeTransition.fade_to_next("res://title.tscn")


func _on_timer_timeout():
	next_scene()
