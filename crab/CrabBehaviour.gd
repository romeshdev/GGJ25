class_name CrabBehaviour extends CharacterBody3D

const STRAFE_ACCELERATION : float = 20
const STRAFE_DECELERATION : float = 5
const STRAFE_DECELERATION_FROM_ROTATION : float = 2 
const STRAFE_DECELERATION_FROM_NO_INPUT : float = 10
const ROTATE_ACCELERATION : float = 20
const ROTATE_DECELERATION : float = 40
const JUMP_VELOCITY : float = 4.5

var rotation_speed : float = 0.0
var input_rotation : float = 0.0 

func _physics_process(delta):
	# Fall down
	var onFloor : bool = is_on_floor()
	if not onFloor:
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and onFloor:
		velocity.y = JUMP_VELOCITY
		
	# Handle rotation
	if input_rotation:
		rotation_speed = move_toward(rotation_speed, input_rotation, ROTATE_ACCELERATION)
	else:
		rotation_speed = move_toward(rotation_speed, 0, ROTATE_DECELERATION)
		
	rotate_y(rotation_speed * delta)

	# Handle strafing
	var input_strafe = Input.get_axis("crab_strafe_left", "crab_strafe_right")
	var direction = (transform.basis * Vector3(input_strafe, 0, 0))
	if input_strafe:
		var acceleration = (direction * STRAFE_ACCELERATION * delta).normalized()
		velocity.x = velocity.x + acceleration.x
		velocity.z = velocity.z + acceleration.z
		
	# Handle friction
	var deceleration = STRAFE_DECELERATION * delta
	deceleration = deceleration * (1 + abs(input_rotation) * STRAFE_DECELERATION_FROM_ROTATION)
	deceleration = deceleration * (1 + (1 - abs(input_strafe)) * STRAFE_DECELERATION_FROM_NO_INPUT)
	velocity.x = move_toward(velocity.x, 0, deceleration)
	velocity.z = move_toward(velocity.z, 0, deceleration)

	move_and_slide()
