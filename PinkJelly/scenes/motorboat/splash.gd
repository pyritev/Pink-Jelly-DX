extends Node2D

@onready var humdeath = preload("res://scenes/motorboat/hum_death.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_audio_stream_player_2d_finished():
	var new_ghost = humdeath.instantiate()
	new_ghost.position = position
	get_parent().add_child(new_ghost)
	queue_free()
