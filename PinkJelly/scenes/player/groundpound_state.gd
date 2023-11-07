extends "res://scenes/player/player_base_state.gd" 

var create_afterimages

func _enter_state(host, state_machine):
	create_afterimages = true # start creating afterimages
	host.animation_player.play("crouch")
	host.gravity = host.gravity * 3
	host.velocity.x = 0

func _tick_state(host, state_machine, delta):
	if host.is_on_floor() and host.cooldown_timer.is_stopped() and host.state_machine.current_state.id == "groundpound":
		# host has landed on the floor
		host.crash_sound.play()
		host.cooldown_timer.start() # start landing cooldown timer
		create_afterimages = false # stop creating afterimages
		
	if create_afterimages: # draw afterimages
		if host.afterimage_timer.is_stopped(): # check if the afterimage cooldown timer has run out
			var after = host.aft.instantiate()
			host.get_parent().add_child(after)
			# set afterimage sprites to be match current player sprite
			after.sprite.hframes = host.sprite.hframes
			after.sprite.texture_filter = host.sprite.texture_filter
			after.sprite.set_texture(host.sprite.texture)
			after.sprite.frame = host.sprite.frame
			after.sprite.flip_h = host.sprite.flip_h
			after.position = host.position
			# restart the afterimage cooldown timer
			host.afterimage_timer.start()

func _exit_state(host, state_machine):
	host.cooldown_timer.stop()
	host.gravity = host.default_gravity


func _on_cooldown_timer_timeout():
	if host.state_machine.current_state.id == "groundpound":
		if Input.is_action_pressed("button_down"):
			host.state_machine.set_state(host, "crouch")
		else:
			host.state_machine.set_state(host, "idle")
	pass # Replace with function body.
