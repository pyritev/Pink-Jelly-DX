extends Node2D

@onready var hbox = $Control/HBoxContainer
var score : int = 123

# Called when the node enters the scene tree for the first time.
func _ready():
	update(Globals.score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update(score : int):
	if score > 99999:
		score = 999999
	var padded_score = str(score).pad_zeros(6)
	var num_array = padded_score.split()
	
	var score_array = []
	for node in hbox.get_children():
		var sprite = node.get_node("Sprite2D")
		score_array.append(sprite)
	
	for i in 6:
		score_array[i].frame = int(num_array[i])
