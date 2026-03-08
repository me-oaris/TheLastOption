extends Control

func _ready():
	get_tree().paused = false	

	var music_player = AudioStreamPlayer.new()
	music_player.stream = load("res://Audio/Game_Completion.mp3")
	add_child(music_player)
	music_player.finished.connect(music_player.play)
	music_player.play()

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file.call_deferred("res://playground.tscn")

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
