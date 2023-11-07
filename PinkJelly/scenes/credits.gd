extends Control

var skipped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	FadeTransition.fade_in()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("button_a") and !skipped:
		FadeTransition.fade_to_next("res://copyright.tscn")
		skipped = true
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "scroll":
		FadeTransition.fade_to_next("res://copyright.tscn")
