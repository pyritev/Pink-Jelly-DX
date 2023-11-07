extends CharacterBody2D

var moving := false

func _physics_process(delta):
	if moving:
		velocity.y = -100

		move_and_slide()


func _on_timer_timeout():
	$Death.play()
	moving = true
	visible = true
	pass # Replace with function body.
