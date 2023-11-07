extends Control

@onready var star_ent = preload("res://scenes/star_from_starbank.tscn")
var skipped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	FadeTransition.hide_fade()
	for n in Globals.stars:
		var new_star = star_ent.instantiate()
		$ColorRect/TextureRect/CenterContainer/GridContainer.add_child(new_star)
	if Globals.stars == 0:
		var new_star = star_ent.instantiate()
		$ColorRect/TextureRect/CenterContainer/GridContainer.add_child(new_star)
		new_star.modulate.a = 0.25
	if (Globals.stars < Globals.stars_to_win):
		$CenterContainer/Label.set_text("COLLECT %d MORE STARS!" % (Globals.stars_to_win - Globals.stars))
	else:
		$CenterContainer/Label.set_text("CONGRATULATIONS!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("button_a") or Input.is_action_just_pressed("button_start"):
		if !skipped:
			Globals.bonus_end()
		skipped = true
