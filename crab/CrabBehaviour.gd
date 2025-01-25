class_name CrabBehaviour extends CharacterBody3D

const MOVE_ACCELERATION : float = 0.2
const MOVE_DECELERATION : float = 0.4
const ROTATE_ACCELERATION : float = 0.2
const ROTATE_DECELERATION : float = 0.4
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
	var direction = (transform.basis * Vector3(input_strafe, 0, 0)).normalized()
	if input_strafe:
		velocity.x = velocity.x + direction.x * MOVE_ACCELERATION
		velocity.z = velocity.z + direction.z * MOVE_ACCELERATION
	else:
		velocity.x = move_toward(velocity.x, 0, MOVE_DECELERATION)
		velocity.z = move_toward(velocity.z, 0, MOVE_DECELERATION)

	move_and_slide()
