extends "res://scenes/player/player_state.gd"

@export var hori_flip = true
@export var can_walk = true
@export var can_jump = true
@export var walk_anim = true

func _enter_state(body, state_machine):
	pass

func _tick_state(body, state_machine, delta):
	tick_movement(delta)

func tick_movement(delta):
	walk(delta)
	jump(delta)
	crouch(delta)

func walk(delta):
	var direction = Input.get_axis("button_left", "button_right")
	if direction and can_walk:
		host.velocity.x = direction * host.speed
		if hori_flip:
			match int(direction):
				-1:
					host.sprite.flip_h = 1
				1:
					host.sprite.flip_h = 0
	else:
		host.velocity.x = move_toward(host.velocity.x, 0, host.speed)

func jump(delta):
	if Input.is_action_just_pressed("button_a") and host.is_on_floor():
		host.velocity.y = -host.jump_power
		host.jump_sound.play()
		host.state_machine.set_state(host, "jump")

func crouch(delta):
	if Input.is_action_just_pressed("button_down"):
		if host.is_on_floor():
			if host.state_machine.current_state.id != "crouch":
				host.state_machine.set_state(host, "crouch")
