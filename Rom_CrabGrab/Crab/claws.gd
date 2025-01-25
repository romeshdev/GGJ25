extends Node3D

@onready var Claw_L = $Claw_L
@onready var Claw_R = $Claw_R

@onready var Claw_L_Pincer = $Claw_L/Pincer
@onready var Claw_L_Pincer_BaseRot = $Claw_L/Pincer.rotation.y

@onready var Claw_R_Pincer = $Claw_R/Pincer
@onready var Claw_R_Pincer_BaseRot = $Claw_R/Pincer.rotation.y

# Called when the node enters the scene tree for the first time.
func _run():
	$Claw_L/Pincer/Pincer.create_convex_collision()
	$Claw_R/Pincer/Pincer.create_convex_collision()

var grip_strenth = .1;
var max_pincer_rotation_degrees = 10

func _physics_process(_delta):
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
