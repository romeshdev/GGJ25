class_name CrabBehaviour extends CharacterBody3D

const STRAFE_ACCELERATION : float = 20
const STRAFE_DECELERATION : float = 5
const STRAFE_DECELERATION_FROM_ROTATION : float = 2 
const STRAFE_DECELERATION_FROM_GROUND_FRICTION : float = 10
const STRAFE_DECELERATION_FROM_AIR_FRICTION : float = 1

const ROTATE_ACCELERATION : float = 20
const ROTATE_DECELERATION : float = 40
const ROTATE_MAX_SPEED : float = 20

const JUMP_VELOCITY : float = 10
const GRAVITY_MIN : float = 0.5
const GRAVITY_MAX : float = 2

var rotation_speed : float = 0.0
var input_rotation : float = 0.0 

func _process(delta):
	# Restore position
	if position.y < -5:
		position = Vector3.UP * 3

func _physics_process(delta):
	# Handle jump
	var onFloor : bool = is_on_floor()
	var holdingJump = Input.is_action_pressed("crab_strafe_left") && Input.is_action_pressed("crab_strafe_right")
	if holdingJump and onFloor:
		velocity.y = JUMP_VELOCITY
		
	# Fall down
	if not onFloor:
		var gravity = get_gravity()
		if holdingJump and velocity.y > 0:
			gravity = gravity * GRAVITY_MIN
		else:
			gravity = gravity * GRAVITY_MAX
		velocity += gravity * delta

	# Handle rotation
	if input_rotation:
		var acceleration : float = ROTATE_ACCELERATION * delta * input_rotation
		rotation_speed = rotation_speed + acceleration
		if abs(rotation_speed) > ROTATE_MAX_SPEED:
			rotation_speed = ROTATE_MAX_SPEED * sign(rotation_speed)
	else:
		var deceleration : float = ROTATE_DECELERATION * delta
		rotation_speed = move_toward(rotation_speed, 0, deceleration)
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
	var friction : float = STRAFE_DECELERATION_FROM_GROUND_FRICTION if onFloor else STRAFE_DECELERATION_FROM_AIR_FRICTION
	deceleration = deceleration * (1 + (1 - abs(input_strafe)) * friction)
	velocity.x = move_toward(velocity.x, 0, deceleration)
	velocity.z = move_toward(velocity.z, 0, deceleration)

 	# Update position
	move_and_slide()
