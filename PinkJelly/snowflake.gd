extends CharacterBody2D

@onready var snowflake = preload("res://snowflake.tscn")
@onready var sprite = $Sprite2D
var speed = 35
var hori_speed = 0
var direction = 0
var rand = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rand.randomize()
	hori_speed = rand.randf_range(3, 8)
	direction = rand.randi_range(-1, 1)
	speed = rand.randf_range(25, 35)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# fixed deltatime issue for potential 1.2 release
	position.y += speed * delta
	position.x += hori_speed * direction * delta

func regen_snowflake():
	# make a new snowflake
	var new_snowflake = snowflake.instantiate()
	# set its position
	new_snowflake.position.x = rand.randi_range(16, 240)
	new_snowflake.position.y = -16 # start above the top of the screen
	# add to parent scene
	get_parent().add_child(new_snowflake)
	# randomize whether it's a flake or a ball
	new_snowflake.sprite.frame = rand.randi_range(0, 1)
	# kill the old snowflake
	self.queue_free()
