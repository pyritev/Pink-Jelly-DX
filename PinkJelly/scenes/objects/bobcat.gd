extends Enemy

@onready var stomp = preload("res://scenes/objects/stomp.tscn")
@onready var sprite = $Sprite2D
@onready var animations_bank = ["walking", "walking_rings"]

@export var direction = 1
var flip_cooldown = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
		initialize()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = speed * direction
	
	if !$Turnaround/RayCast2D.is_colliding():
		flip()
	if !$Turnaround/RayCast2D2.is_colliding():
		flip()
	
	if $Damage/RayCast2D.is_colliding():
		kill_player($Damage/RayCast2D.get_collider())
	if $Damage/RayCast2D2.is_colliding():
		kill_player($Damage/RayCast2D2.get_collider())
		
	
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

func flip():
#	print("flip")
	if !flip_cooldown:
		direction = direction * -1
		sprite.flip_h = not sprite.flip_h
		$Timer.start()
		flip_cooldown = true


#func _on_hurtbox_body_entered(body):
#	if body.name == "Player":
#		body.death("enemy")


func _on_timer_timeout():
	flip_cooldown = false

func initialize():
	$AnimationPlayer.play(animations_bank[variant])
