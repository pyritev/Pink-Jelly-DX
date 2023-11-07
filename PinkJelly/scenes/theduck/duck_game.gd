extends Node2D

@onready var duck = preload("res://scenes/theduck/duck.tscn")
@onready var rising_text = preload("res://scenes/theduck/risingtext.tscn")

var max_ducks = 25
var game_end = false
var ducks_spawned = 0
var ducks_shot = 0
var hurry = false
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var bg = rng.randi_range(0,3)
	match bg:
		0:
			$Sprite2D.frame = 0
		1:
			$Sprite2D.frame = 3
		2:
			$Sprite2D.frame = 6
		3:
			$Sprite2D.frame = 9
	FadeTransition.hide_fade()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("button_a") or Input.is_action_just_pressed("button_b"):
		$Cursor/AudioStreamPlayer2D.play()
	
	$LevelTimer/Label.set_text(Globals.time_convert($LevelTimer.time_left))
	$Label2.set_text(str(max_ducks - ducks_shot))
	$Score.update(Globals.score)

	if $LevelTimer.time_left <= 15 and !hurry:
		hurry = true
		$Music.stop()
		$Hurry.play()

func _on_timer_timeout():
	if $Ducks.get_children().size() < 3 and ducks_spawned < max_ducks:
		ducks_spawned += 1
		spawn_duck()
	elif $Ducks.get_children().size() == 0 and ducks_spawned >= max_ducks and !game_end:
		$Complete.play()
		end_game(true)
	$Timer.start()

func spawn_duck():
	var chance = rng.randi_range(0,1)
	var spawn_position = Vector2.ZERO
	var new_duck = duck.instantiate()
	var random_height = rng.randi_range(-30, 10)
	match chance:
		0:
			spawn_position.x = $Left.position.x
			spawn_position.y = $Left.position.y + (random_height)
			new_duck.horizontal_direction = 1
		1:
			spawn_position.x = $Right.position.x
			spawn_position.y = $Right.position.y + (random_height)
			new_duck.horizontal_direction = -1
	new_duck.position = spawn_position
	# scaling difficulty
	if Globals.bonus_clears[1] > 0:
		new_duck.speed = new_duck.speed * (1 + (float(Globals.bonus_clears[1]) / 2))
	$Ducks.add_child(new_duck)
	new_duck.vertical_direction = -1 if rng.randi_range(0,1) == 0 else 1
	if chance == 1:
		new_duck.sprite.flip_h = true

func _on_area_2d_2_body_entered(body):
	if body is Duck:
		ducks_shot += 1
		var new_text = rising_text.instantiate()
		new_text.position = body.position
		add_child(new_text)
		body.queue_free()


func _on_area_2d_3_body_entered(body):
	Globals.add_score(100)
	body.queue_free()


func _on_level_timer_timeout():
	if !game_end:
		$Fail.play()
		end_game(false)

func end_game(player_won : bool = false):
	game_end = true
	if player_won:
		Globals.add_star()
		Globals.bonus_won = true
		Globals.bonus_clears[1] += 1
	else:
		Globals.bonus_won = false
	$EndTimer.start()
	get_tree().paused = true
	pass


func _on_end_timer_timeout():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/bonus/bonus_results.tscn")


func _on_area_2d_4_body_exited(body):
	if body is Duck and !body.dead: # bitch ass duck flew off
		body.queue_free()
		ducks_spawned -= 1 # refund a duck, the player isn't getting off easy
