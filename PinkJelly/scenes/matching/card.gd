class_name Card
extends Node2D

@export var character = 0
var frame = 0
var active = false
var matched = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.frame = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body is Cursor and !self.active:
			body.focus = self
	pass

func initialize_card():
	$Sprite2D.frame = 0
	frame = character + 1


func _on_area_2d_body_entered(body):
	if body is Cursor and !self.active:
		body.focus = self

func activate():
	if get_tree().current_scene.cards_active.size() < 2 and !matched:
		$Sprite2D.frame = frame
		active = true
		get_tree().current_scene.cards_active.append(self)

func deactivate():
	$Sprite2D.frame = 0
	active = false
