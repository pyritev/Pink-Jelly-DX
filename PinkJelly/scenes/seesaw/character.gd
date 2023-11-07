class_name SeesawCharacter
extends CharacterBody2D

const DEFAULT_HORI_IMPULSE = 60

@export_enum("Jelly", "Chicken") var character = 0

var active = false
var hori_impulse = DEFAULT_HORI_IMPULSE
var vertical_impulse = 0
var collected_item = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if character == 1:
		$Sprite2D.frame = 3
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func impulse(power):
	# scaling difficulty
	if Globals.bonus_clears[2] > 0:
		hori_impulse = DEFAULT_HORI_IMPULSE + (Globals.bonus_clears[2] * 10)
	vertical_impulse = power
	velocity.y -= power
	var direction = -1 if character == 1 else 1
	velocity.x += hori_impulse * direction
	
func die():
	$Die.play()
	$CollisionShape2D.set_deferred("disabled", true)
	velocity = Vector2.ZERO
	$Sprite2D.flip_v = true
	velocity.y = -200
	get_parent().death_timer.start()
	$Timer.start()


func _on_timer_timeout():
	queue_free()
