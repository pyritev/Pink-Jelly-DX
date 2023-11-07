extends CharacterBody2D

@onready var character = preload("res://scenes/seesaw/seesaw_character.tscn")

var movement_speed = 200
var height_increase = 10 # height that is added on each bounce

# original coordinates
var jelly_pos : Vector2
var chicken_pos : Vector2

# pseudo-state
var state = 0 # 0 is initial, 1 is first launch, 2 is jelly in air, 3 is chicken in air

func _ready():
	# put seesaw in the center of the screen
	position.x = get_viewport_rect().size.x/2
	# save original coordinates
	jelly_pos = $Jelly.position
	chicken_pos = $Chicken.position
	set_state(0)

func _physics_process(delta):
	# horizontal movement
	var x_axis = Input.get_axis("button_left", "button_right")
	velocity.x = x_axis * movement_speed
	
	# theoretically the only button input we have to do here is the initial launch
	if Input.is_action_just_pressed("button_a") and state == 0:
		launch_character(0, 350)
		set_state(1)
		$Jump.play()
		
	
	move_and_slide()

func set_state(state : int, reset : bool = true): # set the state of the seesaw
	self.state = state
	match state:
		0: # initial state; nobody has bounced. set here on respawn
			if reset:
				position.x = get_viewport_rect().size.x/2
			$Chicken.position = chicken_pos
			$Jelly.position = jelly_pos
			$Jelly.visible = true
			$Chicken.visible = true
			$Sprite2D.frame = 2
		1: # jelly has jumped, still no bounce
			$Jelly.visible = false
			$Chicken.visible = true
			$Sprite2D.frame = 2
		2: # jelly has been bounced
			$Jelly.visible = false
			$Chicken.position = Vector2(chicken_pos.x + 2, chicken_pos.y + 7)
			$Chicken.visible = true
			$Sprite2D.frame = 0
		3: # chicken has been bounced
			$Jelly.visible = true
			$Jelly.position = Vector2(jelly_pos.x - 2, jelly_pos.y + 7)
			$Chicken.visible = false
			$Sprite2D.frame = 1
	pass

func launch_character(character : int, impulse : int = 350): 	# create a new characterbody annd launch it upwards
	var new_jelly = self.character.instantiate()
	new_jelly.character = character
	get_parent().add_child(new_jelly)
	match character:
		0:
			new_jelly.position = $Jelly.global_position
		1:
			new_jelly.position = $Chicken.global_position
	new_jelly.impulse(impulse)

func _on_jelly_landing_body_entered(body):
	if body is SeesawCharacter:
		if body.velocity.y > 0:
			if body.character == 0: # check if jelly
				if Input.is_action_pressed("button_b"): # catch ?
					set_state(0, false)
				else:
	#				print("YES")
					set_state(3)
					$Land.play()
					# save last impulse and add more height
					var vert_impulse = body.vertical_impulse + height_increase
					launch_character(1, vert_impulse)
				# hide the body
				body.queue_free()
#			else:
#				print("NO")


func _on_chicken_landing_body_entered(body):
	if body is SeesawCharacter:
		if body.velocity.y > 0:
			if body.character == 1: # check if chicken
				if Input.is_action_pressed("button_b"): # catch?
					set_state(0, false)
				else:
	#				print("YES")
					set_state(2)
					$Land.play()
					# save last impulse and add more height
					var vert_impulse = body.vertical_impulse + height_increase
					launch_character(0, vert_impulse)
				# hide the body
				body.queue_free()
#			else:
#				print("NO")
