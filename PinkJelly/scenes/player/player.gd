extends CharacterBody2D

@onready var aft = preload("res://scenes/player/afterimage.tscn")
@onready var sprites = [
	preload("res://assets/images/adventure/jelly.png"),
	preload("res://assets/images/adventure/panda.png"),
	preload("res://assets/images/adventure/hummer.png"),
	preload("res://assets/images/adventure/rings1.png"),
	preload("res://assets/images/adventure/rings2.png"),
	preload("res://assets/images/adventure/rings3.png"),
	preload("res://assets/images/adventure/rings4.png")
	]
@onready var panda_sounds = [
	preload("res://assets/sfx/panda_jump.wav"),
	preload("res://assets/sfx/panda_die.wav"),
	preload("res://assets/sfx/panda_fall.wav")
]
@onready var hummer_sounds = [
	preload("res://assets/sfx/hummer_jump.wav"),
	preload("res://assets/sfx/hummer_death.wav")
]

# player variables
@export var tile_size = 8
var default_gravity = 120 * tile_size
@export var gravity = default_gravity
@export var speed = 9 * tile_size
@export var jump_power = 32 * tile_size
var starting_pos
var has_died = false
var invuln = false

# player objects
@onready var sprite = $Sprite2D
@onready var state_machine = $StateMachine
@onready var animation_player = $AnimationPlayer
@onready var modulate_player = $Modulate
@onready var hitbox = $Regular
@onready var crouch_hitbox = $Crouched
@onready var aft_emitter = $AfterImages
@onready var hud = $HUD

# SFX
@onready var jump_sound = $Jump
@onready var charge_sound = $Charge
@onready var super_jump_sound = $SuperJump
@onready var crash_sound = $CrashSound
@onready var fall_sound = $FallSound
@onready var respawn_sound = $Respawn
@onready var death_sound = $Death

# timers
@onready var crouch_timer = $CrouchTimer
@onready var cooldown_timer = $CooldownTimer
@onready var afterimage_timer = $AftTimer
@onready var death_timer = $DeathTimer


func _ready():
	sprite.texture = sprites[Globals.character]
	if Globals.character == 1:
		fall_sound.stream = panda_sounds[2]
		jump_sound.stream = panda_sounds[0]
		fall_sound.volume_db = 4
		death_sound.stream = panda_sounds[1]
		death_sound.volume_db = 4
	elif Globals.character == 2:
		jump_sound.stream = hummer_sounds[0]
		death_sound.stream = hummer_sounds[1]
		death_sound.volume_db = 4
	hud.get_node("Lives").update(Globals.lives)
	starting_pos = position
	state_machine.set_state(self, "idle")

func _physics_process(delta):
	state_machine.tick_states(self, delta)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func _input(event):
	if (Input.is_action_just_pressed("button_b") and Input.is_action_pressed("button_select")) and (Globals.play_forever):
		Globals.lives += 9
		Globals.added_lives = true
		respawn_sound.play()


func death(type : String):
	if !has_died:
		if type == "fall":
			has_died = true
			state_machine.set_state(self, "death")
			fall_sound.play()
			hitbox.set_deferred("disabled", true)
			crouch_hitbox.set_deferred("disabled", true)
			death_timer.start()
		if type == "enemy":
			if !invuln:
				has_died = true
				state_machine.set_state(self, "death")
				death_sound.play()
				sprite.flip_v = true
				velocity.y = -500
				animation_player.play("idle")
				hitbox.set_deferred("disabled", true)
				crouch_hitbox.set_deferred("disabled", true)
				death_timer.start()

func respawn():
	if Globals.lives > 0:
		Globals.lives -= 1
		hud.get_node("Lives").update(Globals.lives)
		has_died = false
		sprite.flip_v = false
		sprite.flip_h = false
		hitbox.set_deferred("disabled", false)
		state_machine.set_state(self, "idle")
		position = starting_pos
		invuln = true
		modulate_player.play("flicker")
		$InvulnTimer.start()
		respawn_sound.play()
	else:
		Globals.lives = Globals.DEFAULT_LIVES
		FadeTransition.fade_to_next("res://scenes/gameover.tscn")

func _on_invuln_timer_timeout():
	$Modulate.play("default")
	invuln = false

func _on_death_timer_timeout():
	respawn()

func is_falling() -> bool:
	return (velocity.y < 0)

func add_score(score : int):
	Globals.add_score(score)
	hud.get_node("Score").update(Globals.score)

