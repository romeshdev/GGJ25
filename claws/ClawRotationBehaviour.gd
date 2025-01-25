class_name ClawRotatorBehaviour extends Node3D

@export var flip : bool = false

const ROTATION_SPEED : float = 5.0
const MIN_ANGLE : float = 0.0
const MAX_ANGLE : float = PI*0.75
const MIN_ANGLE_FLIPPED : float = PI*1.25
const MAX_ANGLE_FLIPPED : float = 2*PI

var target : Vector2

func _normalizeAngle(angle) -> float:
	var twopi = 2*PI
	while angle < 0:
		angle = angle + twopi
	return fmod(angle, twopi)

func _ready():
	target = Vector2.UP

func _process(delta):
	var angle : float = 0.0
	if flip:
		target.x = max(0.00001, target.x)
		angle = _normalizeAngle(-PI/2 -target.angle())
		angle = clamp(angle, MIN_ANGLE_FLIPPED, MAX_ANGLE_FLIPPED)
	else:
		target.x = min(0, target.x)
		angle = _normalizeAngle(-PI/2 -target.angle())
		angle = clamp(angle, MIN_ANGLE, MAX_ANGLE)
	rotation.y = lerp_angle(rotation.y, angle, delta * ROTATION_SPEED) 
