class_name ClawRotatorBehaviour extends Node3D

const ROTATION_SPEED : float = 5.0
const MIN_ANGLE : float = 0.0
const MAX_ANGLE : float = 2.5

var target : Vector2

func _normalizeAngle(angle) -> float:
	var twopi = 2*PI
	while angle < 0:
		angle = angle + twopi
	return fmod(angle, twopi)

func _ready():
	target = Vector2.UP

func _process(delta):
	target.x = min(0, target.x)
	var angle = _normalizeAngle(-PI/2 -target.angle())
	angle = clamp(angle, MIN_ANGLE, MAX_ANGLE)
	rotation.y = lerp(rotation.y, angle, delta * ROTATION_SPEED) 
