extends "res://scenes/player/player_base_state.gd"

func _enter_state(host, state_machine):
	host.animation_player.play("crouch")
	pass

func _tick_state(host, state_machine, delta):
	if host.animation_player.current_animation != "crouch":
		host.animation_player.play("crouch")
	if host.is_on_floor():
		host.state_machine.set_state(host, "idle")
	tick_movement(delta)
