extends Node2D

@onready var hbox = $Control/HBoxContainer
var score : int = 9

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("extra_life", _on_extra_life)
	update(Globals.lives)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update(score : int):
	if score > 9:
		score = 9
	var padded_score = str(score).pad_zeros(0)
	var num_array = padded_score.split()
	
	var score_array = []
	for node in hbox.get_children():
		var sprite = node.get_node("Sprite2D")
		score_array.append(sprite)
	
	for i in 1:
		score_array[i].frame = int(num_array[i])

func _on_extra_life():
	print("extra life found")
	update(Globals.lives)
