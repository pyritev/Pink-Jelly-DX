extends CharacterBody2D


func _physics_process(delta):
	velocity.y = -200
	move_and_slide()
