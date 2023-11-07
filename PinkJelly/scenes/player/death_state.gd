extends "res://scenes/player/player_base_state.gd"

func _enter_state(host, state_machine):
	host.gravity = host.gravity * 3
	host.velocity.x = 0

func _tick_state(host, state_machine, delta):
	host.velocity.x = 0
	pass

func _exit_state(host, state_machine):
	host.gravity = host.default_gravity
