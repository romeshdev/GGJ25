class_name ClawRotatorBehaviour extends Node3D

@export var flip : bool = false
@export var grabArea : Area3D
@export var actionName : StringName

const ROTATION_SPEED : float = 5.0
const MIN_ANGLE : float = 0.0
const MAX_ANGLE : float = PI*0.75
const MIN_ANGLE_FLIPPED : float = PI*1.25
const MAX_ANGLE_FLIPPED : float = 2*PI

var target : Vector2
var egg : EggBehaviour
var eggIsGrabbed : bool

func _normalizeAngle(angle) -> float:
	var twopi = 2*PI
	while angle < 0:
		angle = angle + twopi
	return fmod(angle, twopi)

func _ready():
	assert(grabArea != null)
	target = Vector2.UP

func _process(delta):
	# Rotate claws
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
	
	# Grab shit
	if Input.is_action_just_pressed(actionName) && egg != null:
		eggIsGrabbed = true
		egg.freeze = true
		egg.linear_velocity = Vector3.ZERO
		egg.angular_velocity = Vector3.ZERO
		
	# Drag shit
	if egg != null && eggIsGrabbed:
		egg.global_position = grabArea.global_position
		
	# Drop shit
	if Input.is_action_just_released(actionName) && egg != null:
		eggIsGrabbed = false
		egg.freeze = false
	

func _on_area_3d_body_entered(body):
	if eggIsGrabbed:
		return
	if body is EggBehaviour:
		egg = body as EggBehaviour

func _on_area_3d_body_exited(body):
	if eggIsGrabbed:
		return
	if body == egg:
		egg = null
