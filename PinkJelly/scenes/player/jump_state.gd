extends "res://scenes/player/player_base_state.gd"

func _enter_state(host, state_machine):
	if Globals.character == 2: # crouch jump if hummer
		host.hitbox.disabled = true
		host.crouch_hitbox.disabled = false
		host.animation_player.play("crouch")
	else:
		host.animation_player.play("jump")
	
func _tick_state(host, state_machine, delta):
	if host.is_on_floor():
		if host.velocity.x == 0:
			host.state_machine.set_state(host, "idle")
		else:
			host.state_machine.set_state(host, "walking")
	tick_movement(delta)

func _exit_state(host, state_machine):
	if Globals.character == 2: # set collision back to normal if hummer
		if !host.has_died:
			host.hitbox.disabled = false
			host.crouch_hitbox.disabled = true

func crouch(delta):
	if Input.is_action_just_pressed("button_down"):
		host.fall_sound.play()
		host.state_machine.set_state(host, "groundpound")
