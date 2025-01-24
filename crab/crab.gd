class_name Crab extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _physics_process(delta):
	# Fall down
	var onFloor : bool = is_on_floor()
	if not onFloor:
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and onFloor:
		velocity.y = JUMP_VELOCITY
		
	# Handle rotation
	var input_rotation = Input.get_axis("crab_rotate_left", "crab_rotate_right")
	rotate_y(input_rotation * delta)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_strafe = Input.get_axis("crab_strafe_left", "crab_strafe_right")
	var direction = (transform.basis * Vector3(input_strafe, 0, 0)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
