class_name Cursor
extends CharacterBody2D

var x_axis = 0
var y_axis = 0

@export var movement_speed = 150

var focus

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !get_parent().game_end:
		x_axis = Input.get_axis("button_left", "button_right")
		y_axis = Input.get_axis("button_up", "button_down")
		velocity = Vector2(x_axis * movement_speed, y_axis * movement_speed)
		
		
		if Input.is_action_just_pressed("button_a") and focus != null:
			if !focus.active:
				focus.activate()
	else:
		velocity = Vector2.ZERO
	move_and_slide()
