extends CharacterBody2D


func _physics_process(delta):
	if Input.is_action_just_pressed("button_a"):
		$AudioStreamPlayer2D.play()
