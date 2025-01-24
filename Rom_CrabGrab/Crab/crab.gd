extends CharacterBody3D

@onready var Claw_L = $CrabBod/Arm_L/GrabbbyBit_L/GrabbyBit_L
@onready var Claw_R = $CrabBod/Arm_R/GrabbbyBit_R/GrabbyBit_R

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var picked_object
var pull_power = 4

func pick_object_L():
	var Collider_L = Claw_L.get_collider()
	if Collider_L != null and Collider_L is RigidBody3D:
		print("Left Claw with a rigid body")
		
func pick_object_R():
	var Collider_R = Claw_R.get_collider()
	if Collider_R != null and Collider_R is RigidBody3D:
		print("Left Claw with a rigid body")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if Input.is_key_pressed(KEY_E):
		pick_object_R()
		
	if Input.is_key_pressed(KEY_Q):
		pick_object_L()
