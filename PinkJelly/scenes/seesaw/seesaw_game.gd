extends Node2D

const STAR_TIME = 30

@onready var object = preload("res://scenes/seesaw/object.tscn")
@onready var seesaw = $Seesaw
@onready var death_timer = $DeathTimer
var object_places = []
var num_objects = 12
var objects_collected = 0
var star_collectable = false
var star_collected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for object_place in $Objects.get_children():
		var new_object = object.instantiate()
		object_place.add_child(new_object)
		object_places.append(object_place)
	SignalBus.connect("object_collected", collect_object)
	FadeTransition.fade_in()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$StarTimer/Label.set_text(Globals.time_convert($StarTimer.time_left))
	$Score.update(Globals.score)


func _on_kill_plane_body_entered(body):
	if body is SeesawCharacter:
		body.die()


func _on_death_timer_timeout():
	seesaw.get_node("Respawn").play()
	seesaw.set_state(0)

func collect_object():
	objects_collected += 1
	if objects_collected >= num_objects and !star_collectable:
		star_ready()
	$RespawnTimer.start()
	pass


func _on_respawn_timer_timeout():
	var num_of_places = object_places.size() - 1
	var random_place = Globals.rng.randi_range(0, num_of_places)
	while object_places[random_place].get_children().size() > 0:
		random_place = Globals.rng.randi_range(0, num_of_places)
	var new_object = object.instantiate()
	object_places[random_place].add_child(new_object)

func star_ready():
	star_collectable = true
	$Star/AnimationPlayer.play("blink")
	if Globals.bonus_clears[2] > 0:
		$StarTimer.set_wait_time(STAR_TIME / (Globals.bonus_clears[2] + 1))
	$StarTimer.start()
	$StarTimer/Label.visible = true
	$Music.stop()
	$Hurry.play()


func _on_star_body_entered(body):
	if body is SeesawCharacter:
		if star_collectable and !star_collected:
			$Star/Collected.play()
			star_collected = true
			end_game(true)

func end_game(player_won : bool = false):
	if player_won:
		Globals.add_star()
		Globals.bonus_won = true
		Globals.bonus_clears[2] += 1
	else:
		Globals.bonus_won = false
	$EndTimer.start()
	get_tree().paused = true
	pass


func _on_star_timer_timeout():
	if !star_collected:
		$Fail.play()
		end_game(false)


func _on_end_timer_timeout():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/bonus/bonus_results.tscn")
