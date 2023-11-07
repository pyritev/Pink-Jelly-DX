extends Node

# User preferences
var master_volume = 5
var music_volume = 5
var stars = 6
var lives = 9

# Called when the node enters the scene tree for the first time.
func _ready():
	load_save()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_save():
	var data_file = ConfigFile.new()
	
	# Load file
	var file = data_file.load("user://sdata.bin")
	
	# Create the file if we don't have one
	if file != OK:
		save_data()
		return
	
	master_volume = data_file.get_value("settings", "master_volume")
	music_volume = data_file.get_value("settings", "music_volume")
	stars = data_file.get_value("settings", "stars")
	lives = data_file.get_value("settings", "lives")
	
	adjust_volume(master_volume, 0)
	adjust_volume(music_volume, 1)

func save_data():
	var data_file = ConfigFile.new()
	
	data_file.set_value("settings", "master_volume", master_volume)
	data_file.set_value("settings", "music_volume", music_volume)
	data_file.set_value("settings", "stars", stars)
	data_file.set_value("settings", "lives", lives)
	
	# Save
	data_file.save("user://sdata.bin")

func adjust_volume(vol, corresponding_bus):
	var volume_value = linear_to_db(((float(vol))/10))
	AudioServer.set_bus_volume_db(corresponding_bus, volume_value)
