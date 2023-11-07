class_name Duck
extends CharacterBody2D

@onready var sprite = $Sprite2D

var in_sights = false
var gravity = 2000
var dead = false
var speed = 80.0
var vertical_direction = -1
var horizontal_direction = 1


func _physics_process(delta):
	
	$Label.set_text(str(speed))
	
	if (Input.is_action_just_pressed("button_a") or Input.is_action_just_pressed("button_b")) and in_sights:
		die()
	
	if ($Horizontal/West.is_colliding() and horizontal_direction == -1) or ($Horizontal/East.is_colliding() and horizontal_direction == 1):
		horizontal_direction = horizontal_direction * -1
		$Sprite2D.flip_h = not $Sprite2D.flip_h
	if ($Vertical/North.is_colliding() and vertical_direction == -1) or ($Vertical/South.is_colliding() and vertical_direction == 1):
		vertical_direction = vertical_direction * -1
	
	if dead:
		velocity.y += gravity * delta
	else:
		velocity = Vector2(speed*horizontal_direction, speed*vertical_direction)
	
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body is Cursor:
		in_sights = true


func _on_area_2d_body_exited(body):
	if body is Cursor:
		in_sights = false

func die():
	$AnimationPlayer.play("DIE")
	dead = true
	$Sprite2D.flip_v = true
	velocity.x = 0
	


func _on_timer_timeout():
	# enable raycasts - fix turnaround bug
	$Horizontal/West.enabled = true
	$Horizontal/East.enabled = true
	$Vertical/North.enabled = true
	$Vertical/South.enabled = true
