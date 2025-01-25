class_name CrabBehaviour extends CharacterBody3D

signal fellOffCliff

const ADVANCE_ACCELERATION : float = 5
const RETREAT_ACCELERATION : float = 2

const STRAFE_ACCELERATION : float = 100
const STRAFE_DECELERATION : float = 6
const STRAFE_DECELERATION_FROM_GROUND_ROTATION : float = 2 
const STRAFE_DECELERATION_FROM_AIR_ROTATION : float = 0.5 
const STRAFE_DECELERATION_FROM_GROUND_FRICTION : float = 10
const STRAFE_DECELERATION_FROM_AIR_FRICTION : float = 1

const ROTATE_ACCELERATION : float = 20
const ROTATE_DECELERATION_GROUND : float = 40
const ROTATE_DECELERATION_AIR : float = 3
const ROTATE_MAX_SPEED : float = 20

const JUMP_VELOCITY : float = 10
const GRAVITY_MIN : float = 0.5
const GRAVITY_MAX : float = 2

const HEADCHECK_SPEED : float = 2

var rotation_speed : float = 0.0
var input_rotation : float = 0.0 
var input_advance : float = 0.0
var camera_target_lateral : float = 0.5

@export var cameraTarget : Node3D
@export var cameraTargetStrafeLeft : Node3D
@export var cameraTargetStrafeRight : Node3D
@export var cameraMan : CameraMan

func _ready():
	assert(cameraTarget != null)
	assert(cameraTargetStrafeLeft != null)
	assert(cameraTargetStrafeLeft != null)
	assert(cameraMan != null)

func _process(delta):
	# Restore position if you fall off a cliff
	if position.y < -10:
		position = Vector3.UP * 3
		velocity = Vector3.ZERO
		fellOffCliff.emit()

func _physics_process(delta):
	# Handle jump
	var onFloor : bool = is_on_floor()
	var holdingJump = Input.is_action_pressed("crab_strafe_left") && Input.is_action_pressed("crab_strafe_right")
	if holdingJump and onFloor:
		velocity.y = JUMP_VELOCITY
		
	# Fall down
	if not onFloor:
		# Variable jumping height
		var gravity = get_gravity()
		if holdingJump and velocity.y > 0:
			gravity = gravity * GRAVITY_MIN
		else:
			gravity = gravity * GRAVITY_MAX
		# Apply helicopter
		var helicopter : float = abs(rotation_speed) / ROTATE_MAX_SPEED
		helicopter = helicopter * helicopter * helicopter
		gravity = gravity * (1 - helicopter)
		# Apply gravity
		velocity += gravity * delta

	# Handle rotation
	if input_rotation and onFloor:
		var acceleration : float = ROTATE_ACCELERATION * delta * input_rotation
		rotation_speed = rotation_speed + acceleration
		if abs(rotation_speed) > ROTATE_MAX_SPEED:
			rotation_speed = ROTATE_MAX_SPEED * sign(rotation_speed)
	else:
		var deceleration_rate : float = ROTATE_DECELERATION_GROUND if onFloor else ROTATE_DECELERATION_AIR 
		var deceleration : float = deceleration_rate * delta
		rotation_speed = move_toward(rotation_speed, 0, deceleration)
	rotate_y(rotation_speed * delta)

	# Handle strafing
	var input_strafe : float = Input.get_axis("crab_strafe_left", "crab_strafe_right")
	if input_strafe != 0:
		var direction : Vector3 = (transform.basis * Vector3(input_strafe, 0, 0))
		var acceleration = direction.normalized() * delta * STRAFE_ACCELERATION
		velocity.x = velocity.x + acceleration.x
		velocity.z = velocity.z + acceleration.z
		
	# Handle advance / retreat
	if input_advance != 0:
		var direction : Vector3 = (transform.basis * Vector3(0, 0, input_advance))
		var acceleration_amount = ADVANCE_ACCELERATION if input_advance < 0 else RETREAT_ACCELERATION
		var acceleration = direction.normalized() * delta * ADVANCE_ACCELERATION
		velocity.x = velocity.x + acceleration.x
		velocity.z = velocity.z + acceleration.z
		
	# Update camera target based on strafe
	var targetInterpolation : float = (input_strafe + 1) / 2
	camera_target_lateral = lerp(camera_target_lateral, targetInterpolation, delta * HEADCHECK_SPEED)
	cameraTarget.global_position = cameraTargetStrafeLeft.global_position.lerp(cameraTargetStrafeRight.global_position, camera_target_lateral)
		
	# Update camera zoom based on strafe / jumping
	var input_move_amount : float = max(abs(input_strafe), abs(input_advance))
	if not onFloor:
		cameraMan.targetZoom = 0
	else:
		cameraMan.targetZoom = 1 - input_move_amount
		
	# Handle friction
	if input_move_amount == 0:
		var deceleration = STRAFE_DECELERATION * delta
		var rotation_friction : float = STRAFE_DECELERATION_FROM_GROUND_ROTATION if onFloor else STRAFE_DECELERATION_FROM_AIR_ROTATION
		deceleration = deceleration * (1 + abs(input_rotation) * rotation_friction)
		var strafing_friction : float = STRAFE_DECELERATION_FROM_GROUND_FRICTION if onFloor else STRAFE_DECELERATION_FROM_AIR_FRICTION
		deceleration = deceleration * (1 + (1 - input_move_amount) * strafing_friction)
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)

 	# Update position
	move_and_slide()
