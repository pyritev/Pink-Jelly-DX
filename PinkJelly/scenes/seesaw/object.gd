extends Area2D

@export var score_value = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	var frame = Globals.rng.randi_range(0,6)
	while frame == 2:
		frame = Globals.rng.randi_range(0,6)
	$Sprite2D.frame = frame


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is SeesawCharacter:
		if !body.collected_item:
			Globals.add_score(score_value)
			body.collected_item = true
			$CollisionShape2D.set_deferred("disabled", true)
			$Sprite2D.visible = false
			$Collect.play()
			SignalBus.object_collected.emit()


func _on_audio_stream_player_2d_finished():
	queue_free()
