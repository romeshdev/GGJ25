extends Node2D

const targetScale : Vector2 = Vector2(2, 2)
const SCALE_SPEED : float = 5.0

@export var target : Control

func _ready() -> void:
	assert(target != null)

func _process(delta: float) -> void:
	if target.has_focus():
		scale = scale.lerp(targetScale, delta * SCALE_SPEED)
	else:
		scale = scale.lerp(Vector2.ONE, delta * SCALE_SPEED)
