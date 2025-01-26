class_name CrabBehaviour extends CharacterBody3D

signal fellOffCliff

const ADVANCE_ACCELERATION : float = 50
const RETREAT_ACCELERATION : float = 20
const ADVANCE_MAX_SPEED : float = 30
const RETREAT_MAX_SPEED : float = 20

const STRAFE_ACCELERATION : float = 140
const STRAFE_DECELERATION : float = 200
const STRAFE_DECELERATION_FROM_GROUND_ROTATION : float = 2 
const STRAFE_DECELERATION_FROM_AIR_ROTATION : float = 0.5 
const STRAFE_DECELERATION_FROM_GROUND_FRICTION : float = 10
const STRAFE_DECELERATION_FROM_AIR_FRICTION : float = 1
const STRAFE_MAX_SPEED : float = 60

const ROTATE_ACCELERATION : float = 3
const ROTATE_DECELERATION_GROUND : float = 80
const ROTATE_DECELERATION_AIR : float = 10
const ROTATE_MAX_SPEED : float = 2

const JUMP_VELOCITY : float = 140
const GRAVITY_MIN : float = 16
const GRAVITY_MAX : float = 30

const HEADCHECK_SPEED : float = 2

const PUSH_FORCE : float = 3

var startPosition : Vector3
var rotation_speed : float = 0.0
var input_rotation : float = 0.0 
var input_advance : float = 0.0
var camera_target_lateral : float = 0.5
var right_claw_position : Vector2
var left_claw_position : Vector2
var fallSoundPlayed : bool = false

@export var cameraTarget : Node3D
@export var cameraTargetStrafeLeft : Node3D
@export var cameraTargetStrafeRight : Node3D
@export var cameraMan : CameraMan

@export var leftClawRotator : ClawRotatorBehaviour
@export var rightClawRotator : ClawRotatorBehaviour

@export var skeleton: Skeleton3D
@export var rightClawHotspot: Node3D
@export var leftClawHotspot: Node3D

@export var fallingSound: AudioStreamPlayer3D

func _ready():
	assert(cameraTarget != null)
	assert(cameraTargetStrafeLeft != null)
	assert(cameraTargetStrafeLeft != null)
	assert(cameraMan != null)
	assert(leftClawRotator != null)
	assert(rightClawRotator != null)
	assert(skeleton != null)
	assert(rightClawHotspot != null)
	assert(leftClawHotspot != null)
	assert(fallingSound != null)
	startPosition = global_position

func _process(_delta):
	# Play falling sound
	if position.y < 70 && !fallSoundPlayed:
		fallingSound.play()
		fallSoundPlayed = true
	
	# Restore position if you fall off a cliff
	if position.y < 9:
		global_position = startPosition
		velocity = Vector3.ZERO
		fellOffCliff.emit()
		
	# Keyboard controls - rotation
	if input_rotation == 0:
		input_rotation = -Input.get_axis("crab_rotate_left", "crab_rotate_right")
		
	# Keyboard control - advance / retreat
	if input_advance == 0:
		input_advance = Input.get_axis("crab_advance", "crab_retreat")

func _physics_process(delta):
	# Handle jump
	var onFloor : bool = is_on_floor()
	var holdingJump = Input.is_action_pressed("crab_strafe_left") && Input.is_action_pressed("crab_strafe_right")
	if holdingJump and onFloor:
		Jukebox.jumpSound.play()
		velocity.y = JUMP_VELOCITY
		if abs(rotation_speed) > 1:
			velocity.y = 2*velocity.y
			rotation_speed = 4*rotation_speed
			Jukebox.spinSound.play()
		
	# Fall down
	if not onFloor:
		# Variable jumping height
		var gravity = get_gravity()
		if holdingJump and velocity.y > 0:
			gravity = gravity * GRAVITY_MIN
		else:
			gravity = gravity * GRAVITY_MAX
		# Apply helicopter
		var helicopter : float = min(1, abs(rotation_speed) / ROTATE_MAX_SPEED)
		helicopter = helicopter * helicopter * helicopter
		gravity = gravity * (1 - 0.1*helicopter)
		# Apply gravity
		velocity += gravity * delta

	# Handle claw positions
	if left_claw_position.length_squared() > 0.1:
		leftClawRotator.target = left_claw_position
	if right_claw_position.length_squared() > 0.1:
		rightClawRotator.target = right_claw_position
		
	# Handle rotation
	if input_rotation and (onFloor or holdingJump):
		var acceleration : float = ROTATE_ACCELERATION * delta * input_rotation
		rotation_speed = rotation_speed + acceleration
		if velocity.y < 0.1 and abs(rotation_speed) > ROTATE_MAX_SPEED:
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
		var isColinearWithVelocity : bool = direction.dot(velocity) > 0
		if !isColinearWithVelocity || velocity.length() < STRAFE_MAX_SPEED:
			var acceleration = direction.normalized() * delta * STRAFE_ACCELERATION
			velocity.x = velocity.x + acceleration.x
			velocity.z = velocity.z + acceleration.z
		
	# Handle advance / retreat
	if input_advance != 0:
		var isAdvance : bool =  input_advance < 0
		var maxSpeed = ADVANCE_MAX_SPEED if isAdvance else RETREAT_MAX_SPEED
		var direction : Vector3 = (transform.basis * Vector3(0, 0, input_advance))
		var isColinearWithVelocity : bool = direction.dot(velocity) > 0
		if !isColinearWithVelocity || velocity.length() < maxSpeed:
			var acceleration_amount = ADVANCE_ACCELERATION if isAdvance else RETREAT_ACCELERATION
			var acceleration = direction.normalized() * delta * acceleration_amount
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
	var airborne = !onFloor or velocity.y > 0
	if !airborne && input_move_amount == 0:
		var deceleration = STRAFE_DECELERATION * delta
		var rotation_friction : float = STRAFE_DECELERATION_FROM_GROUND_ROTATION if airborne else STRAFE_DECELERATION_FROM_AIR_ROTATION
		deceleration = deceleration * (1 + abs(input_rotation) * rotation_friction)
		var strafing_friction : float = STRAFE_DECELERATION_FROM_GROUND_FRICTION if airborne else STRAFE_DECELERATION_FROM_AIR_FRICTION
		deceleration = deceleration * (1 + (1 - input_move_amount) * strafing_friction)
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)

 	# Update position
	move_and_slide()
	
	# Push shit around
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * PUSH_FORCE)
