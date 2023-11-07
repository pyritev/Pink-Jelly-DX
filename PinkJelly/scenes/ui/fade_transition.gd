extends CanvasLayer

var next_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hide_fade():
	$ColorRect/AnimationPlayer.play("FadeFast")

func show_fade():
	$ColorRect/AnimationPlayer.play("ShowFade")

func fade_in():
	$ColorRect/AnimationPlayer.play("FadeIn")

func fade_out():
	$ColorRect/AnimationPlayer.play("FadeOut")

func fade_to_next(scene : String):
	next_scene = scene
#	print("set next scene to " + next_scene)
	fade_out()
	$NextTimer.start()
	
func _on_next_timer_timeout():
	if get_tree().paused == true:
		get_tree().paused = false
	get_tree().change_scene_to_file(next_scene)
