extends CharacterBody2D

var start_direction = 1
var in_motion = false
var launch = 75

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if start_direction == -1:
		$Sprite2D.flip_h = true

func _physics_process(delta):
	if in_motion:
		velocity.y += gravity * delta
		
		if velocity.y > 0:
			if velocity.x < 0:
				$Sprite2D.rotation_degrees = 270
			else:
				$Sprite2D.rotation_degrees = 90
		else:
			$Sprite2D.rotation_degrees = 0
		
		move_and_slide()

func bump():
	$Sprite2D.flip_h = false
	velocity = Vector2.ZERO
	if Globals.bonus_clears[3] == 0:
		velocity.x += 50
	else:
		velocity.x += 50 * (1.2 ** Globals.bonus_clears[3])
	velocity.y -= 350


func _on_timer_timeout():
	in_motion = true
	velocity.x += launch * start_direction
	velocity.y -= 150
	SignalBus.hum_spawned.emit()
