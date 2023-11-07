extends Control

@onready var control = $Control
@onready var font = preload("res://scenes/ui/font.tscn")
@export var center = true
@export var col : Color

@export var text : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_children())
	reload_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reload_text():
	pass
#		letter.position = Vector2(nextpos, nexty)
#		nextpos += 8
