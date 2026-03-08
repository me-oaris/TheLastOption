extends Control

func _ready():
	var music_player = AudioStreamPlayer.new()
	music_player.stream = load("res://Audio/Menu.mp3")
	add_child(music_player)
	music_player.finished.connect(music_player.play)
	music_player.play()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Intro.tscn")

func _on_on_button_exit_pressed():
	get_tree().quit()

func _on_options_pressed():
	print("Options pressed")

func _on_credits_pressed():
	print("Credits pressed")
