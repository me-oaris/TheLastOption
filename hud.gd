extends CanvasLayer

@onready var light_bar = $Control/VBox/LightBar
var player: Node = null

func _ready():
	print("HUD: System Initialized")

	var music_player = AudioStreamPlayer.new()
	music_player.stream = load("res://Audio/Game_Main.mp3")
	add_child(music_player)
	music_player.finished.connect(music_player.play)
	music_player.play()

	var players = get_tree().get_nodes_in_group("Player")

	if players.size() > 0:
		player = players[0]
	else:
		player = get_parent().get_node_or_null("Player")


func _process(_delta):

	if is_instance_valid(player) and player.get("current_energy") != null:

		light_bar.value = player.current_energy
		light_bar.max_value = player.max_light_energy

		var ratio = light_bar.value / light_bar.max_value

		if ratio < 0.25:
			light_bar.modulate = Color(1.0, 0.2, 0.2)
		elif ratio < 0.5:
			light_bar.modulate = Color(1.0, 0.7, 0.2)
		else:
			light_bar.modulate = Color(1.0, 1.0, 1.0)


func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
