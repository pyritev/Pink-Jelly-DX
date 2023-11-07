extends CharacterBody2D

@export var max_movement = 64
@export var speed = 128
@export_enum("Panda Adventure", "Rings") var type = 0
var direction = 1
var original_pos : Vector2

func _ready():
	if type == 1:
		$Sprite2D.frame = 1
	original_pos = self.position

func _physics_process(delta):
	velocity.x = speed * direction
	if (position.x > (original_pos.x + max_movement) and direction == 1) or (position.x < (original_pos.x - max_movement) and direction == -1):
		direction = direction * -1
	move_and_slide()
