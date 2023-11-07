extends "res://scenes/player/player_base_state.gd"

var super_jump = false

func _enter_state(host, state_machine):
	host.animation_player.play("crouch")
	host.hitbox.disabled = true
	host.crouch_hitbox.disabled = false
	pass

func _tick_state(host, state_machine, delta):
	if !Input.is_action_pressed("button_down"):
		host.state_machine.set_state(host, "idle")
	tick_movement(delta)
	if host.velocity.x == 0 and host.crouch_timer.is_stopped() and !super_jump and host.state_machine.current_state.id == "crouch":
		host.crouch_timer.start()

func _exit_state(host, state_machine):
	host.hitbox.disabled = false
	host.crouch_hitbox.disabled = true
	super_jump = false
	host.modulate_player.play("default")
	host.crouch_timer.stop()

func walk(delta):
	host.velocity.x = lerp(host.velocity.x, 0.0, 0.04)
	if host.velocity.x < 4 and host.velocity.x > -4:
		host.velocity.x = 0

func jump(delta):
	if Input.is_action_just_pressed("button_a") and host.is_on_floor():
		if !super_jump:
			host.velocity.y = -host.jump_power
			host.jump_sound.play()
		else:
			host.velocity.y = -host.jump_power * 1.5
			host.super_jump_sound.play()
		host.state_machine.set_state(host, "jump")

func _on_crouch_timer_timeout():
	host.charge_sound.play()
	host.modulate_player.play("power")
	super_jump = true
	pass # Replace with function body.
