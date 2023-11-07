extends Node2D

@onready var snowflake = preload("res://snowflake.tscn")
var rand = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rand.randomize()
	var last_x = 0
	var last_y = 0
	# generate 25 snowflakes
	for n in 25:
		var generated_snowflake = snowflake.instantiate()
		var gen_x = rand.randi_range(16, 240)
		var gen_y = randi_range(16, 224)
		# check if snowflakes are sufficiently spaced apart; not 100% foolproof but hopefully will make it look a little nicer
		if last_x != 0 and last_y != 0:
			if gen_x < last_x - 16 or gen_x > last_x + 16:
				gen_x = rand.randi_range(16, 240) 
			if gen_y < last_y - 16 or gen_y > last_y + 16:
				gen_y = rand.randi_range(16, 224) 
		# set position
		generated_snowflake.position = Vector2(gen_x, gen_y)
		# instantiate
		add_child(generated_snowflake)
		# set the sprite - this can only be done after adding child for some reason
		generated_snowflake.sprite.frame = rand.randi_range(0, 1)
		# save the positions for the above check
		last_x = gen_x
		last_y = gen_y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("Snowflake"):
		body.regen_snowflake()
