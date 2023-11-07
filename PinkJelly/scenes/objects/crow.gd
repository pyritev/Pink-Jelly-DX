extends Enemy

@onready var stomp = preload("res://scenes/objects/stomp.tscn")
@onready var sprite = $Sprite2D

var direction = 1
var vertical_direction = 1
var flip_cooldown = false
var behavior = 0 # 0 = dive, 1 = fly
var rng = RandomNumberGenerator.new()
var animations_bank = ["dive", "fly"]


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	initialize()
	$ChangeTimer.wait_time = rng.randf_range(0.1, 1)

func _physics_process(delta):
	
	velocity.x = speed * direction
	velocity.y = speed * vertical_direction
	
	for raycast in $Damage.get_children():
		if raycast.is_colliding():
			kill_player(raycast.get_collider())
	
	if $Bounds/RayCast2D.is_colliding():
		fly()
	
	if $Bounds/RayCast2D2.is_colliding():
		dive()

	move_and_slide()

func die():
	var poof_effect = stomp.instantiate()
	poof_effect.position = self.position
	get_parent().add_child(poof_effect)
	get_parent().player.add_score(250)
	queue_free()
	
func _on_hitbox_body_entered(body):
	if body.name == "Player" and body.is_falling:
#		$Hurtbox/CollisionShape2D.disabled = true
#		$Hurtbox/CollisionShape2D2.disabled = true
		$CollisionShape2D.disabled = true
		die()
		if body.state_machine.current_state.id != "groundpound":
			body.state_machine.set_state(body, "bounce")
			body.velocity.y = -body.jump_power

func kill_player(body):
	if body.name == "Player":
		body.death("enemy")
	if body.name == "LevelBounds":
		flip()
		
func change(override : bool = false):
	# erratic behavior
	$ChangeTimer.wait_time = rng.randf_range(0.1, 1)
	var mode = 0 if behavior == 1 else 1
	var flip_check = rng.randi_range(0,1)
	if flip_check == 0 or override:
		match mode:
			0:
				# dive
				dive()
				pass
			1:
				# fly
				fly()
				pass
	else:
		flip()
	$ChangeTimer.start()
	pass

func flip():
	if !flip_cooldown:
		direction = -direction
		sprite.flip_h = not sprite.flip_h
		$Timer.start()
		flip_cooldown = true

func fly():
	$AnimationPlayer.play(animations_bank[1])
	behavior = 1
	vertical_direction = -1

func dive():
	$AnimationPlayer.play(animations_bank[0])
	behavior = 0
	vertical_direction = 1
	flip()
	
func _on_timer_timeout():
	flip_cooldown = false


func _on_change_timer_timeout():
	change()

func initialize():
	if variant == 1:
		animations_bank = ["dive_2", "fly_2"]
	else:
		animations_bank = ["dive", "fly"]
	$AnimationPlayer.play(animations_bank[0])
