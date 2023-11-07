extends Node2D


@onready var hummer = preload("res://scenes/motorboat/hummer.tscn")
@onready var humdeath = preload("res://scenes/motorboat/hum_death.tscn")
@onready var humsplash = preload("res://scenes/motorboat/splash.tscn")
@onready var spawns = [$Node/LeftSpawn, $Node/MiddleSpawn, $Node/RightSpawn, $Node/LastSpawn]
var rng = RandomNumberGenerator.new()

var hummer_par := 10
var hummers_saved := 0
var hurry := false
var game_ended := false

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	$LevelTimer/Label.set_text(Globals.time_convert($LevelTimer.time_left))
	SignalBus.connect("hum_spawned", _on_hum_spawned)
	if Globals.bonus_clears[3] > 0:
		hummer_par = hummer_par + (7*Globals.bonus_clears[3])
	$HumsLeft.set_text(str(hummer_par))
	FadeTransition.hide_fade()
	spawn_hummer()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$LevelTimer/Label.set_text(Globals.time_convert($LevelTimer.time_left))
#	if Input.is_action_just_pressed("button_select"):
#		get_tree().reload_current_scene()
	if $LevelTimer.time_left <= 20 and !hurry:
		hurry = true
		$Music.stop()
		$Hurry.play()
		$LevelTimer/AnimationPlayer.play("blink")

func spawn_hummer():
	var spawn_pos = rng.randi_range(0, 3)
	var start_impulse = rng.randi_range(0, 3)
	var new_hummer = hummer.instantiate()
	new_hummer.position = spawns[spawn_pos].position
	match start_impulse:
		0:
			new_hummer.launch = 10
		0:
			new_hummer.launch = 50
		1:
			new_hummer.launch = 75
		2:
			new_hummer.launch = 150
	if(spawn_pos == 3):
		new_hummer.start_direction = -1
	add_child(new_hummer)
	
func end_game():
	game_ended = true
	if hummers_saved < hummer_par:
		Globals.bonus_won = false
	else:
		Globals.stars += 1
		Globals.bonus_won = true
		Globals.bonus_clears[3] += 1
	get_tree().change_scene_to_file("res://scenes/bonus/bonus_results.tscn")
		

func _on_success_zone_body_entered(body):
	if body.is_in_group("hummer"):
		hummers_saved += 1
		$HumsLeft.set_text(str(hummer_par - hummers_saved))
		$Saved.play()
		body.queue_free()
		if(hummers_saved >= hummer_par):
			$Complete.play()
			$EndTimer.start()
			get_tree().paused = true
		else:
			spawn_hummer()
			toggle_blink(false)


func _on_kill_zone_body_entered(body):
	if body.is_in_group("hummer"):
		var new_time = $LevelTimer.time_left - 5
		if(new_time <= 0):
			new_time = 1
		$LevelTimer.stop()
		$LevelTimer.wait_time = new_time
		$LevelTimer.start()
		var new_splash = humsplash.instantiate()
		new_splash.position = body.position
		add_child(new_splash)
		body.queue_free()
		toggle_blink(false)

func toggle_blink(blink := true):
	if blink:
		$AnimationPlayer.play("blink")
	else:
		$AnimationPlayer.play("stop")


func _on_ghost_zone_body_entered(body):
	if body is CharacterBody2D:
		body.queue_free()
		spawn_hummer()


func _on_level_timer_timeout():
	$EndTimer.start()
	$Fail.play()
	get_tree().paused = true

func _on_hum_spawned():
	toggle_blink(true)


func _on_end_timer_timeout():
	get_tree().paused = false
	end_game()
