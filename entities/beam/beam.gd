extends Node2D

const ARC_SEGMENTS := 16

@export_range(0.0, 720.0, 1.0, "radians_as_degrees") var sweep_speed: float = deg_to_rad(90.0)
@export_range(0.5, 90.0, 0.5, "radians_as_degrees") var beam_half_width: float = deg_to_rad(12.0)
@export_range(1.0, 1500.0, 1.0) var beam_range: float = 400.0
@export var beam_color: Color = Color(1.0, 0.9, 0.4, 0.35)

var beam_angle: float = 0.0


func _physics_process(delta: float) -> void:
	beam_angle = fposmod(beam_angle + sweep_speed * delta, TAU)


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var points := PackedVector2Array([Vector2.ZERO])
	var start_angle := beam_angle - beam_half_width
	var step := beam_half_width * 2.0 / ARC_SEGMENTS
	for i in ARC_SEGMENTS + 1:
		points.append(Vector2.from_angle(start_angle + step * i) * beam_range)
	draw_colored_polygon(points, beam_color)
