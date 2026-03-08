extends Area2D

@export var pulse_speed: float = 2.0
@export var pulse_min_scale: float = 0.85
@export var pulse_max_scale: float = 1.15
@export var flood_speed: float = 0.5

var _base_scale: Vector2
var _time: float = 0.0
var is_flooding: bool = false
var canvas_modulate: CanvasModulate = null

func _ready() -> void:
	_base_scale = scale
	canvas_modulate = get_parent().get_node("CanvasModulate")
	if not canvas_modulate:
		push_error("WinOrb: Could not find CanvasModulate node!")

func _process(delta: float) -> void:
	_time += delta * pulse_speed
	
	var current_pulse_max = pulse_max_scale
	if is_flooding:
		current_pulse_max *= 1.5
		
	var pulse = lerp(pulse_min_scale, current_pulse_max, (sin(_time) + 1.0) / 2.0)
	scale = _base_scale * pulse
	
	if canvas_modulate:
		var target_color = Color.WHITE if is_flooding else Color(0.05, 0.05, 0.05, 1.0)
		canvas_modulate.color = canvas_modulate.color.lerp(target_color, flood_speed * delta)

func start_flood() -> void:
	is_flooding = true

func stop_flood() -> void:
	is_flooding = false
