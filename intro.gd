extends Control

@onready var label = $CenterContainer/VBoxContainer/StoryLabel


var story_text = [
	"The world has fallen into eternal darkness...",
	"Resources are gone. Hope is fading.",
	"Deep within the ancient labyrinth lies the only chance for survival:",
	"The 'Orb of Light'.",
	"Many have entered. None have returned.",
	"You are our final hope.",
	"You are... [color=red]The Last Option.[/color]"
]

var current_line = 0

func _ready():
	var music_player = AudioStreamPlayer.new()
	music_player.stream = load("res://Audio/Intro.mp3")
	add_child(music_player)
	music_player.finished.connect(music_player.play)
	music_player.play()

	display_next_line()

func display_next_line():
	if current_line < story_text.size():
		label.text = "[center]" + story_text[current_line] + "[/center]"
		label.modulate.a = 0
		
		var tween = create_tween()
		tween.tween_property(label, "modulate:a", 1.0, 1.5)
		tween.tween_interval(2.0)
		tween.tween_property(label, "modulate:a", 0.0, 1.0)
		tween.finished.connect(_on_line_finished)
	else:
		start_game()

func _on_line_finished():
	current_line += 1
	display_next_line()

func _input(event):
	if event.is_pressed():
		start_game()

func start_game():
	get_tree().change_scene_to_file("res://playground.tscn")
