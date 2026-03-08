extends Control

func _ready():
	get_tree().paused = false

	var sfx_player = AudioStreamPlayer.new()
	sfx_player.stream = load("res://Audio/Screech.mp3")
	add_child(sfx_player)
	sfx_player.play()

func _on_pressed():
	get_tree().change_scene_to_file("res://playground.tscn")

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
