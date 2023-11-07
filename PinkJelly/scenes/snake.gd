extends Node2D

var b_press = 0
var stopped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("button_b"):
		Globals.secret_player.play()
		if b_press < 4:
			if stopped:
				$Sprite2D.visible = false
				$Timer.start()
				$Music.play()
				stopped = false
			else:
				b_press += 1
		else:
			stopped = true
			b_press = 0
			$Music.stop()
			$AnimationPlayer.play("idle")
	if event.is_action_pressed("button_start"):
		get_tree().change_scene_to_file("res://title.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	$Sprite2D.visible = true
	$AnimationPlayer.play("flip")
