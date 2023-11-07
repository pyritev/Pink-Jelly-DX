extends CharacterBody2D

const DEFAULT_SPEED = 100.0
const MAX_SPEED = 250.0

var speed := DEFAULT_SPEED

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):

	if Input.is_action_just_pressed("button_b"):
		speed = MAX_SPEED
		$AnimationPlayer.speed_scale = 1.5
	elif Input.is_action_just_released("button_b"):
		speed = DEFAULT_SPEED
		$AnimationPlayer.speed_scale = 1

	var direction = Input.get_axis("button_left", "button_right")
	if direction:
		velocity.x = direction * speed
		match int(direction):
			-1:
				$Sprite2D.flip_h = true
			1:
				$Sprite2D.flip_h = false
				
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("hummer"):
		$Bounce.play()
		body.bump()
