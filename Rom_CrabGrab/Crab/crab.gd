extends CharacterBody3D

@onready var Claw_L = $CrabBod/Claw_L
@onready var Claw_R = $CrabBod/Claw_R


@onready var Claw_L_Pincer = $CrabBod/Claw_L/Pincer
@onready var Claw_L_Pincer_BaseRot = $CrabBod/Claw_L/Pincer.rotation.y

@onready var Claw_R_Pincer = $CrabBod/Claw_R/Pincer
@onready var Claw_R_Pincer_BaseRot = $CrabBod/Claw_R/Pincer.rotation.y

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var picked_object
var pull_power = 4

# This represents the player's inertia.
var push_force = .5

func _run():
	$CrabBod/Claw_L/Pincer/Pincer.create_convex_collision()
	$CrabBod/Claw_R/Pincer/Pincer.create_convex_collision()

#func _ready():
	#$CrabBod/Claw_L/Pincer/Pincer.mesh.create_trimesh_collision();
	#$CrabBod/Claw_R/Pincer/Pincer.mesh.create_trymesh_collision();
#func pick_object_L():
	#var Collider_L = Claw_L.get_collider()
	#if Collider_L != null and Collider_L is RigidBody3D:
		#print("Left Claw with a rigid body")
		#
#func pick_object_R():
	#var Collider_R = Claw_R.get_collider()
	#if Collider_R != null and Collider_R is RigidBody3D:
		#print("Left Claw with a rigid body")

var grip_strenth = .1;
var base_
var max_pincer_rotation_degrees = 10

func _physics_process(delta):
	var right_min_rotation = max_pincer_rotation_degrees
	var right_max_rotation = (max_pincer_rotation_degrees * -1)
	var right_claw_str = (.5 - Input.get_action_strength("crab_right_claw")) * grip_strenth
	print("Right claw:")
	print(right_claw_str)
	print(Claw_R_Pincer.rotation_degrees.y)
	var r_fully_opened = Claw_R_Pincer.rotation_degrees.y >= right_min_rotation
	var r_fully_closed = Claw_R_Pincer.rotation_degrees.y <= right_max_rotation
	if (!r_fully_opened and !r_fully_closed or ((r_fully_opened and right_claw_str < 0) or (r_fully_closed and right_claw_str > 0))):
		Claw_R_Pincer.rotate_y(right_claw_str)
		
	var final_r_rotation_y = Claw_R_Pincer.rotation_degrees.y
	if(final_r_rotation_y > 0 and final_r_rotation_y > right_min_rotation):
		Claw_R_Pincer.rotation_degrees = Vector3(0, right_min_rotation, 0)
		
	if(final_r_rotation_y < 0 and final_r_rotation_y < right_max_rotation):
		Claw_R_Pincer.rotation_degrees = Vector3(0, right_max_rotation, 0)
	
	
	var left_min_rotation = (max_pincer_rotation_degrees * -1)
	var left_max_rotation = max_pincer_rotation_degrees
	var left_claw_str = (-.5 + Input.get_action_strength("crab_left_claw")) * grip_strenth
	print("Left claw:")
	print(left_claw_str)
	print(Claw_L_Pincer.rotation_degrees.y)
	var l_fully_opened = Claw_L_Pincer.rotation_degrees.y <= left_min_rotation
	var l_fully_closed = Claw_L_Pincer.rotation_degrees.y >= left_max_rotation
	if (!l_fully_opened and !l_fully_closed or ((l_fully_opened and left_claw_str > 0) or (l_fully_closed and left_claw_str < 0))):
		Claw_L_Pincer.rotate_y(left_claw_str)
	
	var final_l_rotation_y = Claw_L_Pincer.rotation_degrees.y
	if(final_l_rotation_y > 0 and final_l_rotation_y > left_max_rotation):
		Claw_L_Pincer.rotation_degrees = Vector3(0, left_max_rotation, 0)
		
	if(final_l_rotation_y < 0 and final_l_rotation_y < left_min_rotation):
		Claw_L_Pincer.rotation_degrees = Vector3(0, left_min_rotation, 0)
	
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
	
	# after calling move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
	#
	#if Input.is_key_pressed(KEY_E):
		#pick_object_R()
		#
	#if Input.is_key_pressed(KEY_Q):
		#pick_object_L()
