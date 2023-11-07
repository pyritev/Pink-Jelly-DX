extends CharacterBody2D

enum {IDLE, RUN, JUMP}

const JUMP_VELOCITY = -300.0
const MAX_SPEED = 200
var button_to_press = 0
var speed = 0
var state = IDLE
var cooldown = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	#debug text
	var text = "STATE: %s\nSPEED: %f\nTIMER: %f" % [str(state), velocity.x, $Timer.time_left]
	$CanvasLayer/Label.set_text(text)
	
	if Input.is_action_just_pressed("button_select"):
		get_tree().reload_current_scene()
	
	if is_on_floor() and velocity.x == 0 and state != IDLE:
		state = IDLE
		$AnimationPlayer.play("idle")
	if is_on_floor() and velocity.x != 0 and state != RUN:
		state = RUN
		$AnimationPlayer.play("running")
	if !is_on_floor() and state != JUMP:
		state = JUMP
		$AnimationPlayer.play("jump")
	
	match state:
		RUN:
			$AnimationPlayer.speed_scale = speed / 100 if speed / 100 >= 0.5 else 0.5
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
#
	# Handle Jump.
	if Input.is_action_just_pressed("button_a") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	match button_to_press:
		0:
			if Input.is_action_just_pressed("button_left"):
				if $Timer.time_left > 0:
					$Timer.stop()
				button_to_press = 1
				speed += 10
		1:
			if Input.is_action_just_pressed("button_right"):
				if $Timer.time_left > 0:
					$Timer.stop()
				button_to_press = 0
				speed += 10
	
	velocity.x = speed
	velocity.x = clamp(velocity.x, 0, MAX_SPEED)
	if !Input.is_action_pressed("button_left") and !Input.is_action_pressed("button_right"):
		if !cooldown:
			velocity.x = lerp(velocity.x, 0.0, 0.6)
		elif !($Timer.time_left > 0) and state != 0: # check if cooldown timer isn't running yet
			print("run timer")
			$Timer.start()
			cooldown = true
	
	move_and_slide()


func _on_timer_timeout():
	cooldown = false
