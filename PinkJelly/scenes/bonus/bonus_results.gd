extends Control

@export var type : int = 0
@onready var sprite = $VBoxContainer/CenterContainer/Control/StarGet
@onready var sprite_toobad = $VBoxContainer/CenterContainer/Control/TooBad
@onready var rects = [
	$ColorRect,
	$ColorRect2,
	$ColorRect3
]

var skipped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	FadeTransition.fade_in()
	if Globals.bonus_won:
		$Success.play()
		type = Globals.bonus_type
		sprite.frame = type if type != 3 else 0
		match type:
			0, 3:
				# matching
				rects[0].visible = true
				rects[1].visible = false
				rects[2].visible = false
			1:
				# the duck
				rects[0].visible = false
				rects[1].visible = true
				rects[2].visible = false
			2:
				# seesaw
				rects[0].visible = false
				rects[1].visible = false
				rects[2].visible = true
	else:
		$Fail.play()
		rects[0].visible = false
		rects[1].visible = false
		rects[2].visible = false
		$ColorRect4.visible = true
		sprite.visible = false
		sprite_toobad.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("button_a") or Input.is_action_just_pressed("button_start"):
		if !skipped:
			skip()


func _on_timer_timeout():
	# todo: redirect to star bank instead
	skip()

func skip():
	if !skipped:
		skipped = true
		if Globals.bonus_won:
			FadeTransition.fade_to_next("res://scenes/star_bank.tscn")
		else:
			Globals.bonus_end()
