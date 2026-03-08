extends CharacterBody2D

@export var speed: int = 200
@export var max_light_energy: float = 3
@export var global_drain_speed: float = 0.05
@export var hazard_drain_speed: float = 0.5
@export var win_scene: String = "res://main_menu.tscn"
@export var win_delay: float = 2.5

@onready var sprite_2d = $Sprite2D
@onready var player_light = $PointLight2D
@onready var camera = $Camera2D

@export var acceleration: float = 2400.0
@export var friction: float = 1800.0
@export var light_pulse_speed: float = 1.5
@export var light_pulse_strength: float = 0.05

@onready var animation_player : AnimationPlayer = $AnimationPlayer

var current_energy: float = 0.0
var is_in_hazard := false
var is_near_win_orb := false
var game_ending := false
var win_timer: float = 0.0
var win_orb_ref: Node = null


func _ready():
	current_energy = max_light_energy
	if player_light:
		player_light.energy = current_energy
	if camera:
		camera.position_smoothing_enabled = true
		camera.position_smoothing_speed = 8.0


func _physics_process(delta):
	if game_ending:
		return

	var input_direction = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	
	if input_direction != Vector2.ZERO:
		velocity = velocity.move_toward(input_direction * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	move_and_slide()
	
	var target_scale = Vector2.ONE
	var target_rotation = 0.0
	
	if input_direction != Vector2.ZERO:
		var bob = sin(Time.get_ticks_msec() * 0.015) * 0.15
		target_scale = Vector2(1.0 - bob, 1.0 + bob)
		
		if input_direction.x != 0:
			target_rotation = input_direction.x * 0.1
	
	sprite_2d.scale = sprite_2d.scale.lerp(target_scale, 15.0 * delta)
	sprite_2d.rotation = lerp(sprite_2d.rotation, target_rotation, 10.0 * delta)

	if input_direction != Vector2.ZERO:
		update_animations(input_direction)
	else:
		if animation_player.current_animation != "idle":
			animation_player.play("idle")

	if player_light:
		if is_near_win_orb:
			win_timer += delta
			current_energy = lerp(current_energy, max_light_energy * 1.5, 2.0 * delta)
			if win_timer >= win_delay:
				trigger_win()
		else:
			win_timer = 0.0
			var current_drain = global_drain_speed
			if is_in_hazard:
				current_drain += hazard_drain_speed
			
			current_energy -= current_drain * delta
			current_energy = max(0.0, current_energy)
			
			if current_energy <= 0.05: # Small buffer
				game_over()

		var pulse = sin(Time.get_ticks_msec() * 0.001 * light_pulse_speed) * light_pulse_strength
		player_light.energy = current_energy + pulse
		
		var ratio = current_energy / max_light_energy
		
		if ratio < 0.25 and camera:
			var shake_intensity = (0.25 - ratio) * 20.0
			camera.offset = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		elif camera:
			camera.offset = camera.offset.lerp(Vector2.ZERO, 5.0 * delta)


func update_animations(direction: Vector2):

	if abs(direction.x) > abs(direction.y):
		if animation_player.current_animation != "walk_side":
			animation_player.play("walk_side")

		sprite_2d.flip_h = direction.x < 0

	else:
		if direction.y > 0:
			if animation_player.current_animation != "walk_down":
				animation_player.play("walk_down")
		else:
			if animation_player.current_animation != "walk_up":
				animation_player.play("walk_up")


func _on_darkness_zone_body_entered(_body):
	is_in_hazard = true

func _on_darkness_zone_body_exited(_body):
	is_in_hazard = false


func _on_win_orb_body_entered(body: Node2D) -> void:
	if body == self:
		is_near_win_orb = true
		win_timer = 0.0
		win_orb_ref = get_parent().get_node("WinOrb")
		if win_orb_ref:
			win_orb_ref.start_flood()
		else:
			push_error("Player: Could not find WinOrb node!")

func _on_win_orb_body_exited(body: Node2D) -> void:
	if body == self:
		is_near_win_orb = false
		win_timer = 0.0
		if win_orb_ref:
			win_orb_ref.stop_flood()


func game_over():
	game_ending = true
	set_physics_process(false)
	get_tree().change_scene_to_file.call_deferred("res://GameOverDarkness.tscn")


func trigger_win():
	game_ending = true
	set_physics_process(false)
	get_tree().change_scene_to_file.call_deferred("res://GameCompleted.tscn")
